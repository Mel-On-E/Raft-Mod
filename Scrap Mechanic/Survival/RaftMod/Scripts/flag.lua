dofile( "$SURVIVAL_DATA/Scripts/game/survival_quests.lua" )
dofile( "$SURVIVAL_DATA/Scripts/game/managers/QuestManager.lua" )

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
    local windDirection = -dirMiddle:cross(up)
    windDirection = windDirection:normalize()

    --Quest helper
    if not Server_isQuestCompleted(quest_radio_location) then
        windDirection = self.shape:getWorldPosition() - sm.vec3.new(-1820.5, 167.5, -7)
    elseif not Server_isQuestCompleted(quest_find_trader) then
        windDirection = self.shape:getWorldPosition() - sm.vec3.new(1536, 2048, 20)
    end

    windDirection = self.shape:transformPoint(windDirection)
    windDirection = windDirection:normalize()



    local rotation = sm.vec3.getRotation( self.shape.at, sm.vec3.new(0,0,1) )
    local vec = self.shape:transformPoint(self.shape.right):normalize()
    rotation = rotation * sm.vec3.getRotation( vec, sm.vec3.new(1,0,0) )
    --rotation = rotation * sm.vec3.getRotation( self.shape.up, self.shape.right )
    --rotation = rotation * sm.vec3.getRotation( self.shape.up, windDirection )
    --self.effect:setOffsetRotation(self.shape:getWorldRotation())
end