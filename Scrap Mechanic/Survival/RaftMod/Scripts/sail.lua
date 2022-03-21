Sail = class()

function Sail.client_onCreate(self)
    self.effect = sm.effect.createEffect("ShapeRenderable", self.interactable)
    self.effect:setOffsetPosition(sm.vec3.new(0, 1, 0))
    self.effect:setScale(sm.vec3.new(0.1, 1, 1))
    self.effect:setParameter("uuid", sm.uuid.new("628b2d61-5ceb-43e9-8334-a4135566df7a"))
    self.effect:start()
end

function Sail.server_onCreate(self)
    self.size = 10
end

function Sail.client_onRefresh(self)
    local effect = sm.effect.createEffect("ShapeRenderable")
    effect:setPosition(sm.vec3.new(0, 0, 0))
    effect:setScale(sm.vec3.new(1, 1, 1))
    effect:setParameter("uuid", sm.uuid.new("628b2d61-5ceb-43e9-8334-a4135566df7a"))
    effect:start()
end

function Sail.server_onFixedUpdate(self, dt)
    local up = sm.vec3.new(0, 0, 1)
    local dirMiddle = self.shape:getWorldPosition():normalize()
    local forceDirection = dirMiddle:cross(up):normalize()
    local velFactor = math.min(10, math.abs(self.shape:getVelocity():dot(forceDirection)))
    local factor = math.abs(self.shape:getRight():dot(forceDirection))
    local balance = 10 - velFactor
    local force = self.size * 30 * dt * factor * balance
    sm.physics.applyImpulse(self.shape, forceDirection * force, true)
end