dofile("$SURVIVAL_DATA/Scripts/game/survival_quests.lua")

Antenna = class()
Antenna.maxParentCount = 0
Antenna.maxChildCount = 0
Antenna.connectionInput = sm.interactable.connectionType.none
Antenna.connectionOutput = sm.interactable.connectionType.none

function Antenna.server_completeQuest( self, character, state )
	g_questManager:sv_completeQuest(quest_radio_interactive)
    self.network:sendToClients("cl_playEffect")
end

function Antenna.client_onCreate( self )
	self.effect = sm.effect.createEffect( "Antenna - Activation", self.interactable )
end

function Antenna.client_onInteract( self, character, state )
	if state == true then
        self.network:sendToServer("server_completeQuest")
	end
end

function Antenna.client_canInteract(self)
    return not g_questManager:cl_isQuestCompleted(quest_radio_interactive)
end

function Antenna.cl_playEffect(self)
    self.effect:start()
end
