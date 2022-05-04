Breathe = class()
Breathe.maxChildCount = 0
Breathe.maxParentCount = 1
Breathe.connectionInput = sm.interactable.connectionType.power + sm.interactable.connectionType.seated
Breathe.connectionOutput = sm.interactable.connectionType.none
Breathe.colorNormal = sm.color.new("#ff3200")
Breathe.colorHighlight = sm.color.new("#ff1100")

function Breathe:server_onCreate()
    self.sv = {}
    self.sv.player = nil
end

function Breathe:server_onFixedUpdate( dt )
    local parent = self.interactable:getSingleParent()
    if not parent then return end

    local seatedChar = parent:getSeatCharacter()
    if not seatedChar then
        if self.sv.player ~= nil then
            sm.event.sendToPlayer(self.sv.player, "sv_setBlockBreatheDeplete", false)
            self.sv.player = nil
        end

        return
    end

    local seatedPlayer = seatedChar:getPlayer()
    if seatedPlayer ~= nil and self.sv.player == nil then
        self.sv.player = seatedPlayer
        sm.event.sendToPlayer(self.sv.player, "sv_setBlockBreatheDeplete", true)
    end
end