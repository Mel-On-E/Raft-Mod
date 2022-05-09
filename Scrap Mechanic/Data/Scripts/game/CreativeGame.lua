dofile( "$SURVIVAL_DATA/Scripts/game/managers/UnitManager.lua" )
dofile( "$SURVIVAL_DATA/Scripts/game/util/recipes.lua" )

--Raft
dofile( "$SURVIVAL_DATA/Scripts/game/managers/QuestManager.lua" )
dofile( "$SURVIVAL_DATA/RaftMod/Scripts/versionChecker.lua" )
--Raft

CreativeGame = class( nil )
CreativeGame.enableLimitedInventory = false
CreativeGame.enableRestrictions = true
CreativeGame.enableFuelConsumption = false
CreativeGame.enableAmmoConsumption = false
CreativeGame.enableUpgradeCost = true

g_godMode = true
g_disableScrapHarvest = true

function CreativeGame.server_onCreate( self )
	g_unitManager = UnitManager()
	g_unitManager:sv_onCreate( nil, { aggroCreations = true } )

	local time = sm.storage.load( STORAGE_CHANNEL_TIME )
	if time then
		print( "Loaded timeData:" )
		print( time )
	else
		time = {}
		time.timeOfDay = 0.5
		sm.storage.save( STORAGE_CHANNEL_TIME, time )
	end

	--Raft
	g_questManager = QuestManager()
	g_questManager:sv_onCreate( self )
	g_questManager:sv_activateQuest( quest_use_terminal )
	g_questManager:sv_completeQuest( quest_pickup_logbook )
	--Raft

	self.network:setClientData( { time = time.timeOfDay } )

	self:loadCraftingRecipes()
end

--Raft
function CreativeGame:sv_shootSpear( args )
	sm.event.sendToWorld( args.world, "sv_shootSpear", args.data )
end
--Raft

function CreativeGame.loadCraftingRecipes( self )
	LoadCraftingRecipes({
		--Raft
		workbench = "$SURVIVAL_DATA/CraftingRecipes/workbench.json",
		dispenser = "$SURVIVAL_DATA/CraftingRecipes/dispenser.json",
		cookbot = "$SURVIVAL_DATA/CraftingRecipes/cookbot.json",
		craftbot = "$SURVIVAL_DATA/CraftingRecipes/craftbot.json",
		dressbot = "$SURVIVAL_DATA/CraftingRecipes/dressbot.json",
		farm = "$SURVIVAL_DATA/CraftingRecipes/farm.json",
		scrappurifier = "$SURVIVAL_DATA/CraftingRecipes/scrappurifier.json",
		scraptrees = "$SURVIVAL_DATA/CraftingRecipes/scraptrees.json",
		scrapworkbench = "$SURVIVAL_DATA/CraftingRecipes/scrapworkbench.json",
		apiary = "$SURVIVAL_DATA/CraftingRecipes/apiary.json",
		quest1 = "$SURVIVAL_DATA/CraftingRecipes/quest1.json",
		questsail = "$SURVIVAL_DATA/CraftingRecipes/questsail.json",
		questpropeller = "$SURVIVAL_DATA/CraftingRecipes/questpropeller.json",
		questveggies = "$SURVIVAL_DATA/CraftingRecipes/questveggies.json",
		questharpoon = "$SURVIVAL_DATA/CraftingRecipes/questharpoon.json",
		questfinal = "$SURVIVAL_DATA/CraftingRecipes/questfinal.json",
		seedpress = "$SURVIVAL_DATA/CraftingRecipes/seedpress.json",
		grill = "$SURVIVAL_DATA/CraftingRecipes/grill.json",
		scrapdecor = "$SURVIVAL_DATA/CraftingRecipes/scrapdecor.json",
		bigfarm = "$SURVIVAL_DATA/CraftingRecipes/bigfarm.json"
		--Raft
	})
end

function CreativeGame.server_onFixedUpdate( self, timeStep )
	g_unitManager:sv_onFixedUpdate()

	--Raft
	g_questManager:sv_onFixedUpdate()
	
	--RAFT
	if g_checkForUpdates then
		checkRaftVersion()
	end
	--Raft
end

function CreativeGame.server_onPlayerJoined( self, player, newPlayer )
	g_unitManager:sv_onPlayerJoined( player )

	--Raft
	g_questManager:sv_onPlayerJoined( player )
	--Raft
end

function CreativeGame.client_onCreate( self )
	if not sm.isHost then
		self:loadCraftingRecipes()
	end

	sm.game.bindChatCommand( "/noaggro", { { "bool", "enable", true } }, "cl_onChatCommand", "Toggles the player as a target" )
	sm.game.bindChatCommand( "/noaggrocreations", { { "bool", "enable", true } }, "cl_onChatCommand", "Toggles whether the Tapebots will shoot at creations" )
	sm.game.bindChatCommand( "/aggroall", {}, "cl_onChatCommand", "All hostile units will be made aware of the player's position" )
	sm.game.bindChatCommand( "/popcapsules", { { "string", "filter", true } }, "cl_onChatCommand", "Opens all capsules. An optional filter controls which type of capsules to open: 'bot', 'animal'" )
	sm.game.bindChatCommand( "/killall", {}, "cl_onChatCommand", "Kills all spawned units" )
	sm.game.bindChatCommand( "/dropscrap", {}, "cl_onChatCommand", "Toggles the scrap loot from Haybots" )
	sm.game.bindChatCommand( "/place", { { "string", "harvestable", false } }, "cl_onChatCommand", "Places a harvestable at the aimed position. Must be placed on the ground. The harvestable parameter controls which harvestable to place: 'stone', 'tree', 'birch', 'leafy', 'spruce', 'pine'" )
	sm.game.bindChatCommand( "/restrictions", { { "bool", "enable", true } }, "cl_onChatCommand", "Toggles restrictions on creations" )
	sm.game.bindChatCommand( "/day", {}, "cl_onChatCommand", "Sets time of day to day" )
	sm.game.bindChatCommand( "/night", {}, "cl_onChatCommand", "Sets time of day to night" )

	self.cl = {}
	if sm.isHost then
		self.clearEnabled = false
		sm.game.bindChatCommand( "/allowclear", { { "bool", "enable", true } }, "cl_onChatCommand", "Enabled/Disables the /clear command" )
		sm.game.bindChatCommand( "/clear", {}, "cl_onChatCommand", "Remove all shapes in the world. It must first be enabled with /allowclear" )
	end

	if g_unitManager == nil then
		assert( not sm.isHost )
		g_unitManager = UnitManager()
	end
	g_unitManager:cl_onCreate()

	--Raft
	if g_questManager == nil then
		assert( not sm.isHost )
		g_questManager = QuestManager()
	end
	g_questManager:cl_onCreate()
	--Raft
end

--Raft
function CreativeGame.cl_n_questMsg( self, params )
	g_questManager:cl_handleMsg( params )
end
--Raft

function CreativeGame.client_onClientDataUpdate( self, clientData )
	sm.game.setTimeOfDay( clientData.time )
	sm.render.setOutdoorLighting( clientData.time )
end

function CreativeGame.client_showMessage( self, params )
	sm.gui.chatMessage( params )
end

function CreativeGame.cl_onClearConfirmButtonClick( self, name )
	if name == "Yes" then
		self.cl.confirmClearGui:close()
		self.network:sendToServer( "sv_clear" )
	elseif name == "No" then
		self.cl.confirmClearGui:close()
	end
	self.cl.confirmClearGui = nil
end

function CreativeGame.sv_clear( self, _, player )
	if player.character and sm.exists( player.character ) then
		sm.event.sendToWorld( player.character:getWorld(), "sv_e_clear" )
	end
end

function CreativeGame.cl_onChatCommand( self, params )
	if params[1] == "/place" then
		local range = 7.5
		local success, result = sm.localPlayer.getRaycast( range )
		if success then
			params.aimPosition = result.pointWorld
		else
			params.aimPosition = sm.localPlayer.getRaycastStart() + sm.localPlayer.getDirection() * range
		end
		self.network:sendToServer( "sv_n_onChatCommand", params )
	elseif params[1] == "/allowclear" then
		local clearEnabled = not self.clearEnabled
		if type( params[2] ) == "boolean" then
			clearEnabled = params[2]
		end
		self.clearEnabled = clearEnabled
		sm.gui.chatMessage( "/clear is " .. ( self.clearEnabled and "Enabled" or "Disabled" ) )
	elseif params[1] == "/clear" then
		if self.clearEnabled then
			self.clearEnabled = false
			self.cl.confirmClearGui = sm.gui.createGuiFromLayout( "$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout" )
			self.cl.confirmClearGui:setButtonCallback( "Yes", "cl_onClearConfirmButtonClick" )
			self.cl.confirmClearGui:setButtonCallback( "No", "cl_onClearConfirmButtonClick" )
			self.cl.confirmClearGui:setText( "Title", "#{MENU_YN_TITLE_ARE_YOU_SURE}" )
			self.cl.confirmClearGui:setText( "Message", "#{MENU_YN_MESSAGE_CLEAR_MENU}" )
			self.cl.confirmClearGui:open()
		else
			sm.gui.chatMessage( "/clear is disabled. It must first be enabled with /allowclear" )
		end
	else
		self.network:sendToServer( "sv_n_onChatCommand", params )
	end
end

function CreativeGame.sv_n_onChatCommand( self, params, player )
	if params[1] == "/noaggro" then
		local aggro = not sm.game.getEnableAggro()
		if type( params[2] ) == "boolean" then
			aggro = not params[2]
		end
		sm.game.setEnableAggro( aggro )
		self.network:sendToClients( "client_showMessage", "AGGRO: " .. ( aggro and "On" or "Off" ) )
	elseif params[1] == "/noaggrocreations" then
		local aggroCreations = not g_unitManager:sv_getHostSettings().aggroCreations
		if type( params[2] ) == "boolean" then
			aggroCreations = not params[2]
		end
		g_unitManager:sv_setHostSettings( { aggroCreations = aggroCreations } )
		self.network:sendToClients( "client_showMessage", "AGGRO CREATIONS: " .. ( aggroCreations and "On" or "Off" ) )
	elseif params[1] == "/popcapsules" then
		g_unitManager:sv_openCapsules( params[2] )
	elseif params[1] == "/dropscrap" then
		local disableScrapHarvest = not g_disableScrapHarvest
		if type( params[2] ) == "boolean" then
			disableScrapHarvest = not params[2]
		end
		g_disableScrapHarvest = disableScrapHarvest
		self.network:sendToClients( "client_showMessage", "SCRAP LOOT: " .. ( g_disableScrapHarvest and "Off" or "On" ) )
	elseif params[1] == "/restrictions" then
		local restrictions = not sm.game.getEnableRestrictions()
		if type( params[2] ) == "boolean" then
			restrictions = params[2]
		end
		sm.game.setEnableRestrictions( restrictions )
		self.network:sendToClients( "client_showMessage", "RESTRICTIONS: " .. ( restrictions and "On" or "Off" ) )
	elseif params[1] == "/day" then
		local time = { timeOfDay = 0.5 }
		sm.storage.save( STORAGE_CHANNEL_TIME, time )
		self.network:setClientData( { time = 0.5 } )
	elseif params[1] == "/night" then
		local time = { timeOfDay = 0.0 }
		sm.storage.save( STORAGE_CHANNEL_TIME, time )
		self.network:setClientData( { time = 0.0 } )
	else
		if sm.exists( player.character ) then
			params.player = player
			sm.event.sendToWorld( player.character:getWorld(), "sv_e_onChatCommand", params )
		end
	end
end
