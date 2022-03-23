dofile( "$SURVIVAL_DATA/Scripts/game/survival_quests.lua" )

if ENABLE_FUTURE then
	dofile( "$FUTURE_DATA/Scripts/game/survival_quests.lua" )
end
-- Server side
QuestManager = class( nil )

local QuestVersion = 1

local QuestState = { inactive = 1, active = 2, completed = 3 }

--Server to client
NETWORK_MSG_QUEST_STATES = 10000
--Client to server

local DEBUG_QUEST = true
function debug_print( ... )
	if DEBUG_QUEST then
		print(...)
	end
end

-- Server game environment

function QuestManager.sv_loadQuests( self )
	self.sv.quests = {}
	
	for k,v in pairs( SurvivalQuests ) do
		self.sv.quests[k] = v
	end

	if ENABLE_FUTURE then
		for k,v in pairs( FutureQuests ) do
			self.sv.quests[k] = v
		end
	end
end

function QuestManager.sv_onCreate( self, game )
	self.game = game
	
	self.sv = {}
	self.sv.questCompleteObservers = {}

	self:sv_loadQuests()

	self.sv.saved = sm.storage.load( STORAGE_CHANNEL_QUESTS )
	if self.sv.saved then
		debug_print( "Loaded quests with version", self.sv.saved.version, ":" )
		debug_print( self.sv.saved )
	else
		self.sv.saved = { version = QuestVersion, questStates = {} }
		self:sv_saveQuests()
	end
end

function QuestManager.sv_onFixedUpdate( self )
	if self.sv.dirtyQuests then
		self:sv_saveQuests()
		self:sv_sendQuests()
		self.sv.dirtyQuests = false
	end
end

function QuestManager.sv_saveQuests( self )
	sm.storage.save( STORAGE_CHANNEL_QUESTS, self.sv.saved )
end

function QuestManager.sv_sendQuests( self, player )
	if player then
		self.game.network:sendToClient( player, "cl_n_questMsg", { msg = NETWORK_MSG_QUEST_STATES, data = self.sv.saved.questStates, initialization = true } )
	else
		self.game.network:sendToClients( "cl_n_questMsg", { msg = NETWORK_MSG_QUEST_STATES, data = self.sv.saved.questStates } )
	end
end

function QuestManager.sv_onPlayerJoined( self, player )
	self:sv_sendQuests( player )
end

-- Server any environment

function QuestManager.sv_getOrCreateQuestState( self, uuid )
	if uuid and self.sv.quests[uuid] then
		local questStates = self.sv.saved.questStates
		assert( questStates )
		if questStates[uuid] == nil then
			debug_print("Create quest state {"..uuid.."}")
			questStates[uuid] = { state = QuestState.inactive, data = self.sv.quests[uuid].data }
		end
		return questStates[uuid]
	end
end

function QuestManager.sv_updateQuestState( self, uuid, fn )
	local questState = self:sv_getOrCreateQuestState( uuid )
	if questState and questState.state == QuestState.active then
		fn( questState.data )
		debug_print( "Update quest state {"..uuid.."} data:", questState.data )

		local isCompleted = self.sv.quests[uuid].isCompleted( questState.data )
		if isCompleted then
			self:sv_completeQuest( uuid )
		end

		self.sv.dirtyQuests = true
	end
end

function QuestManager.sv_activateQuest( self, uuid )	
	local questState = self:sv_getOrCreateQuestState( uuid )
	if questState and questState.state ~= QuestState.completed then
		questState.state = QuestState.active
		debug_print("Activate quest {"..uuid.."}")
		self.sv.dirtyQuests = true
	end
end

function QuestManager.sv_completeQuest( self, uuid )
	if uuid then
		local questState = self:sv_getOrCreateQuestState( uuid )
		if questState then

			questState.state = QuestState.completed
			debug_print("Complete quest {"..uuid.."}")

			self:sv_notifyObservers( uuid, questState )

			local followupQuestUuid = self.sv.quests[uuid].followup
			if followupQuestUuid then
				self:sv_activateQuest( followupQuestUuid, true )
			end

			self.sv.dirtyQuests = true
		end
	end
end

function QuestManager.sv_activateAllQuests( self )
	for uuid, _ in pairs( self.sv.quests ) do
		self:sv_activateQuest( uuid )
	end
end

function QuestManager.sv_completeAllQuests( self )
	for uuid, _ in pairs( self.sv.quests ) do
		self:sv_completeQuest( uuid )
	end
end

function QuestManager.sv_notifyObservers( self, uuid, questState )
	if questState and questState.state == QuestState.completed then
		local observers = self.sv.questCompleteObservers[uuid]
		if observers then
			for _, observer in ipairs( observers ) do
				pcall( observer )
			end
			self.sv.questCompleteObservers[uuid] = nil
		end
	end	
end

function QuestManager.sv_getQuestState( self, uuid )
	if uuid then
		return self.sv.saved.questStates[uuid]
	end
end

function QuestManager.sv_isQuestActive( self, uuid )
	if uuid then
		local questState = self:sv_getQuestState( uuid )
		if questState then
			return questState.state == QuestState.active
		end
	end
	return false
end

function QuestManager.sv_isQuestCompleted( self, uuid )
	if uuid then
		local questState = self:sv_getQuestState( uuid )
		if questState then
			return questState.state == QuestState.completed
		end
	end
	return false
end

function QuestManager.sv_registerOnCompleteObserver( self, uuid, fn )
	if uuid then
		if not self.sv.questCompleteObservers[uuid] then
			self.sv.questCompleteObservers[uuid] = {}
		end
		table.insert( self.sv.questCompleteObservers[uuid], fn )
	end
end

-- Client game environment

function QuestManager.cl_onCreate( self )
	self.cl = {}
	self.cl.questStates = {}
	self.cl.questCompleteObservers = {}
end

function QuestManager.cl_handleMsg( self, params )
	if params.msg == NETWORK_MSG_QUEST_STATES then
		self.cl.questStates = params.data

		for uuid, questState in pairs( self.cl.questStates ) do
			self:cl_notifyObservers( uuid, questState, not params.initialization )
		end
	end
end

-- Client any environment

function QuestManager.cl_notifyObservers( self, uuid, questState, observed )
	if questState and questState.state == QuestState.completed then
		local observers = self.cl.questCompleteObservers[uuid]
		if observers then
			for _, observer in ipairs( observers ) do
				pcall( observer, observed )
			end
		end
		self.cl.questCompleteObservers[uuid] = nil
	end	
end

function QuestManager.cl_getQuestState( self, uuid )
	if uuid then
		return self.cl.questStates[uuid]
	end
end

function QuestManager.cl_isQuestActive( self, uuid )
	if uuid then
		local questState = self:cl_getQuestState( uuid )
		if questState then
			return questState.state == QuestState.active
		end
	end
	return false
end

function QuestManager.cl_isQuestCompleted( self, uuid )
	if uuid then
		local questState = self:cl_getQuestState( uuid )
		if questState then
			return questState.state == QuestState.completed
		end
	end
	return false
end

function QuestManager.cl_registerOnCompleteObserver( self, uuid, fn  )
	if uuid then
		if not self.cl.questCompleteObservers[uuid] then
			self.cl.questCompleteObservers[uuid] = {}
		end
		table.insert( self.cl.questCompleteObservers[uuid], fn )
	end
end

-- Utilities
-- Server
function Server_activateQuest( uuid )
	if g_questManager then
		g_questManager:sv_activateQuest( uuid )
	end
end

function Server_completeQuest( uuid )
	if g_questManager then
		g_questManager:sv_completeQuest( uuid )
	end
end

function Server_isQuestActive( uuid )
	if g_questManager and g_questManager:sv_isQuestActive( uuid ) then
		return true
	end
	return false
end

function Server_isQuestCompleted( uuid )
	if g_questManager and g_questManager:sv_isQuestCompleted( uuid ) then
		return true
	end
	return false
end

function Server_updateQuestState( uuid, fn )
	if g_questManager then
		g_questManager:sv_updateQuestState( uuid, fn)
	end
end

function Server_registerOnCompleteQuestObserver( uuid, fn )
	if g_questManager then
		if g_questManager:sv_isQuestCompleted( uuid ) then
			fn()
		else
			g_questManager:sv_registerOnCompleteObserver( uuid, fn )
		end
	end
end

-- Client 

function Client_isQuestActive( uuid )
	if g_questManager and g_questManager:cl_isQuestActive( uuid ) then
		return true
	end
	return false
end

function Client_isQuestCompleted( uuid )
	if g_questManager and g_questManager:cl_isQuestCompleted( uuid ) then
		return true
	end
	return false
end

function Client_registerOnCompleteQuestObserver( uuid, fn )
	if g_questManager then
		if g_questManager:cl_isQuestCompleted( uuid ) then
			fn( false )
		else
			g_questManager:cl_registerOnCompleteObserver( uuid, fn )
		end
	end
end