Converter = class()
Converter.maxChildCount = -1
Converter.maxParentCount = 1
Converter.connectionInput = sm.interactable.connectionType.power
Converter.connectionOutput = sm.interactable.connectionType.logic
Converter.colorNormal = sm.color.new("#ff3200")
Converter.colorHighlight = sm.color.new("#ff1100")

local inputs = {
    forward = {
        [1] = "w",
        [-1] = "s"
    },
    steer = {
        [1] = "d",
        [-1] = "a"
    }
}

function Converter:server_onCreate()
    self.modes = self.storage:load()

    if self.modes == nil then
        self.modes = {
            modes = {
                "w",
                "a",
                "s",
                "d"
            },
            count = 1
        }
    end
end

function Converter:server_onFixedUpdate( dt )
    local parent = self.interactable:getSingleParent()
    if not parent then return end

    local selectedInput = self.modes.modes[self.modes.count]
    local forward = parent:getSteeringPower()
    local steer = parent:getSteeringAngle()

    if forward ~= 0 and inputs.forward[forward] == selectedInput then
        self:sv_updateState( { active = true, power = forward, index = 6 } )
        return
    elseif forward == 0 and isAnyOf(selectedInput, inputs.forward) and self.interactable:isActive() then
        self:sv_updateState( { active = false, power = 0, index = 0 } )
    end

    if steer ~= 0 and inputs.steer[steer] == selectedInput then
        self:sv_updateState( { active = true, power = steer, index = 6 } )
        return
    elseif steer == 0 and isAnyOf(selectedInput, inputs.steer) and self.interactable:isActive() then
        self:sv_updateState( { active = false, power = 0, index = 0 } )
    end
end

function Converter:sv_updateState( args )
    self.interactable:setActive( args.active )
    self.interactable:setPower( args.power )

    self.network:sendToClients("cl_uvUpdate", args.index)
end

function Converter:sv_save()
    self.storage:save( self.modes )
end

function Converter:cl_uvUpdate( index )
    self.interactable:setUvFrameIndex( index )
end

function Converter:client_canInteract()
	sm.gui.setInteractionText( "", "Current mode: "..self.modes.modes[self.modes.count]:upper() )

    return true
end

function Converter:client_onInteract( char, lookAt )
    if lookAt then
        self.modes.count = self.modes.count < #self.modes.modes and self.modes.count + 1 or 1
        sm.audio.play("PaintTool - ColorPick")
        self.network:sendToServer("sv_save")
    end
end