Propeller = class()
Propeller.maxParentCount = 0
Propeller.maxChildCount = 0
Propeller.connectionInput = sm.interactable.connectionType.none
Propeller.connectionOutput = sm.interactable.connectionType.none

function Propeller:server_onFixedUpdate(dt)
	angular = self.shape:getBody():getAngularVelocity()

	vec = self.shape.at
	speed = sm.vec3.dot(angular, vec)
	if math.abs(speed) > 1 then
		sm.physics.applyImpulse( self.shape:getBody(), sm.vec3.new(10,10,10) * speed * self.shape:getAt(), true )
	end
end

function Propeller:client_canInteract()
	return false
end