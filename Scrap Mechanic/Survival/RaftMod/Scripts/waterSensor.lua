Sensor = class()
Sensor.maxChildCount = -1
Sensor.maxParentCount = 0
Sensor.connectionInput = sm.interactable.connectionType.none
Sensor.connectionOutput = sm.interactable.connectionType.logic
Sensor.colorNormal = sm.color.new("#0033ff")
Sensor.colorHighlight = sm.color.new("#0000ff")

function Sensor:server_onCreate()
    self.trigger = sm.areaTrigger.createAttachedBox( self.interactable, sm.vec3.one() / 6, sm.vec3.zero(), sm.quat.identity(), 8 )
end

function Sensor:server_onFixedUpdate( dt )
    if not self.trigger then return end

    local isInWater = false
    for _, result in ipairs( self.trigger:getContents() ) do
        if sm.exists( result ) then
            local userData = result:getUserData()
            if userData and userData.water then
                isInWater = true
            end
        end
    end

    self:sv_updateState( { active = isInWater, power = isInWater == true and 1 or 0, index = isInWater == true and 6 or 0  } )
end

function Sensor:sv_updateState( args )
    self.interactable:setActive( args.active )
    self.interactable:setPower( args.power )

    self.network:sendToClients("cl_uvUpdate", args.index)
end

function Sensor:cl_uvUpdate( index )
    self.interactable:setUvFrameIndex( index )
end