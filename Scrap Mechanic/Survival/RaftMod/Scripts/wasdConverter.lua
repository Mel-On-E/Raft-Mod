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

local uv = {
    w = {
        [0] = 0,
        [1] = 6,
    },
    a = {
        [0] = 1,
        [1] = 7,
    },
    s = {
        [0] = 2,
        [1] = 8,
    },
    d = {
        [0] = 3,
        [1] = 9,
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
        self:sv_updateState( { active = true, power = forward } )
    elseif selectedInput == "s" or selectedInput == "w" then
        self:sv_updateState( { active = false, power = 0 } )
    end

    if steer ~= 0 and inputs.steer[steer] == selectedInput then
        self:sv_updateState( { active = true, power = steer } )
    elseif selectedInput == "a" or selectedInput == "d" then
        self:sv_updateState( { active = false, power = 0 } )
    end
end

function Converter:sv_updateState( args )
    self.interactable:setActive( args.active )
    self.interactable:setPower( math.abs(args.power) ) --thank you thrusters

    self:sv_updateUV( args.power )
end

function Converter:sv_updateUV( power )
    local index = uv[self.modes.modes[self.modes.count]][math.abs(power)]
    self.network:sendToClients("cl_uvUpdate", index)
end

function Converter:sv_save()
    self.storage:save( self.modes )
    self:sv_updateUV(0)
end

function Converter:cl_uvUpdate( index )
    self.interactable:setUvFrameIndex( index )
end

function Converter:client_canInteract()
	sm.gui.setInteractionText( "", "Current mode: #df7f00"..self.modes.modes[self.modes.count]:upper() )
    sm.gui.setInteractionText( "", "'"..sm.gui.getKeyBinding( "Use" ).."' to cycle forwards, '"..sm.gui.getKeyBinding( "Tinker" ).."' to cycle backwards.")

    return true
end

function Converter:client_onInteract( char, lookAt )
    if lookAt then
        self.modes.count = self.modes.count < #self.modes.modes and self.modes.count + 1 or 1
        sm.audio.play("PaintTool - ColorPick")
        self.network:sendToServer("sv_save")
    end
end

function Converter:client_onTinker( char, lookAt )
    if lookAt then
        self.modes.count = self.modes.count > 1 and self.modes.count - 1 or #self.modes.modes
        sm.audio.play("PaintTool - ColorPick")
        self.network:sendToServer("sv_save")
    end
end