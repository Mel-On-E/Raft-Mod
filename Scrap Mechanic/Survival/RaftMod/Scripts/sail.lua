Sail = class()
Sail.maxParentCount = 1
Sail.maxChildCount = 0
Sail.connectionInput = sm.interactable.connectionType.logic
Sail.connectionOutput = sm.interactable.connectionType.none
Sail.colorNormal = sm.color.new( 0xff8000ff )
Sail.colorHighlight = sm.color.new( 0xff9f3aff )

local STRENGTH = 1000


function Sail.server_onCreate(self)
    self.size = 10
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

    if self.sv.active then
        local up = sm.vec3.new(0, 0, 1)
        local dirMiddle = self.shape:getWorldPosition():normalize()
        local forceDirection = dirMiddle:cross(up):normalize()
        local velFactor = math.min(10, math.abs(self.shape:getVelocity():dot(forceDirection)))
        local factor = math.abs(self.shape:getRight():dot(forceDirection))
        local balance = 10 - velFactor
        local force = self.size * STRENGTH * dt * factor * balance
        sm.physics.applyImpulse(self.shape, forceDirection * force, true)
    end
end



function Sail.client_onCreate(self)
    self.effect = sm.effect.createEffect("ShapeRenderable", self.interactable)
    self.effect:setOffsetPosition(sm.vec3.new(0, 1, 0))
    self.effect:setScale(sm.vec3.new(0.118, 0.08, 0.1))
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