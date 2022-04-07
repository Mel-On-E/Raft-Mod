Sail = class()
Sail.maxParentCount = 1
Sail.maxChildCount = 0
Sail.connectionInput = sm.interactable.connectionType.logic
Sail.connectionOutput = sm.interactable.connectionType.none
Sail.colorNormal = sm.color.new( 0xff8000ff )
Sail.colorHighlight = sm.color.new( 0xff9f3aff )

local POWER = 10000
local MAX_SPEED = 10


function Sail.server_onCreate(self)
    self.sv = {}
    self.sv.active = false
    self.network:setClientData( self.sv.active )
end

function Sail.sv_changeState(self)
    self.sv.active = not self.sv.active
    self.network:setClientData( self.sv.active )
end

function Sail.server_onFixedUpdate(self, dt)
    parent = self.interactable:getSingleParent()
	if parent then
        if parent.active ~= self.sv.active then
            self:sv_changeState()
        end
    end

    if self.sv.active and self.shape:getVelocity():length() < MAX_SPEED then
        local up = sm.vec3.new(0, 0, 1)
        local dirMiddle = self.shape:getWorldPosition():normalize()
        local windDirection = -dirMiddle:cross(up):normalize()
        local sailDirection = -self.shape:getUp()

        local cosine = windDirection:dot(sailDirection)/(windDirection:length() + sailDirection:length())*-2
        --sm.gui.chatMessage(tostring(cosine))

        local speedFraction = 1 - (self.shape:getVelocity():length() / MAX_SPEED)
        local force = sailDirection * (POWER * speedFraction * dt * cosine)
        force.z = 0
        sm.physics.applyImpulse(self.shape, force, true)
        --print(self.shape:getVelocity():length())
    end
end



function Sail.client_onCreate(self)
    self.effect = sm.effect.createEffect("ShapeRenderable", self.interactable)
    self.effect:setOffsetPosition(sm.vec3.new(0, 1, 0))
    self.effect:setScale(sm.vec3.new(0.118, 0.135, 0.1))
    self.effect:setParameter("uuid", sm.uuid.new("4a971f7d-14e6-454d-bce8-0879243c4934"))
end

function Sail.client_onClientDataUpdate( self, state )
	self.active = state
    if self.active and not self.effect:isPlaying() then
        self.effect:start()
    elseif not self.active and self.effect:isPlaying() then
        self.effect:stop()
    end
end

function Sail.client_canInteract( self, character, state )
    parent = self.interactable:getSingleParent()
    if parent then
        sm.gui.setInteractionText("Controlled by interactable")
        return false
    end

    local keyBindingText = sm.gui.getKeyBinding( "Use" )
    if self.active then
        sm.gui.setInteractionText("", keyBindingText, "Tie up sail")
    else
        sm.gui.setInteractionText("", keyBindingText, "Lower sail")
    end
    return true
end

function Sail.client_onInteract( self, character, state )
	if state == true then
        self.network:sendToServer("sv_changeState")
    end
end