Flag = class()

function Flag.client_onCreate(self)
    self.effect = sm.effect.createEffect("ShapeRenderable", self.interactable)
    self.effect:setOffsetPosition(sm.vec3.new(0, 0.5, 0))
    self.effect:setParameter("uuid", sm.uuid.new("628b2d61-5ceb-43e9-8334-a4135566df7a"))
	self.effect:setParameter("color", sm.color.new(1,0,0))
	self.effect:setScale(sm.vec3.new(0.4, 0.4, 0.1))
    self.effect:start()
end

function Flag.client_onFixedUpdate( self, dt )
    local up = sm.vec3.new(0, 0, 1)
    local dirMiddle = self.shape:getWorldPosition():normalize()
    local windDirection = dirMiddle:cross(up):normalize()

    windDirection = self.shape:transformPoint(windDirection)

    local rotation = sm.vec3.getRotation( sm.vec3.new( 0, 0, 1 ), windDirection )
    self.effect:setOffsetRotation(rotation)
end