Steer = class()
Steer.maxChildCount = -1
Steer.maxParentCount = 1
Steer.connectionInput = sm.interactable.connectionType.power
Steer.connectionOutput = sm.interactable.connectionType.logic
Steer.colorNormal = sm.color.new("#00ff33")
Steer.colorHighlight = sm.color.new("#00ff00")

function Steer:server_onCreate()
    self.modes = self.storage:load()

    if self.modes == nil then
        self.modes = {
            modes = {
                "Vertical + Horizontal",
                "Vertical",
                "Horizontal",
                "Roll"
            },
            count = 1
        }
    end
end

function Steer:server_onFixedUpdate( dt )
    local parent = self.interactable:getSingleParent()
    if not parent then
        self:sv_updateState( { active = false, power = 0, index = 1  } )
        return
    end

    local seatedChar = parent:getSeatCharacter()
    if not seatedChar then
        self:sv_updateState( { active = false, power = 0, index = 1  } )
        return
    end

    local charDir = seatedChar:getDirection()
    local parentShape = parent:getShape()
    local parentDir = parentShape:getRight():cross(parentShape:getAt()) --a seat's getAt is upwards
    local forceDir = parentDir:cross(charDir)

    local bodyToRotate = parentShape:getBody()
    local creationMass = 0
    for v, k in pairs(self.shape:getBody():getCreationShapes()) do
        creationMass = creationMass + k:getBody():getMass()
    end

    local selectedMode = self.modes.modes[self.modes.count]
    if selectedMode == self.modes.modes[2] then
        forceDir.z = 0
    elseif selectedMode == self.modes.modes[3] then
        forceDir.y = 0
    elseif selectedMode == self.modes.modes[4] then
        forceDir.y = 0
        forceDir.z = 0
        forceDir = parentDir * parent:getSteeringAngle()
    end

    sm.physics.applyTorque( bodyToRotate, forceDir * (creationMass / 75) * forceDir:length(), true )
    self:sv_updateState( { active = true, power = 1, index = 7 } )
end

function Steer:sv_updateState( args )
    self.interactable:setActive( args.active )
    self.interactable:setPower( args.power )

    self.network:sendToClients("cl_uvUpdate", args.index)
end

function Steer:sv_save()
    self.storage:save( self.modes )
end

function Steer:cl_uvUpdate( index )
    self.interactable:setUvFrameIndex( index )
end

function Steer:client_canInteract()
	sm.gui.setInteractionText( "", "Current mode: "..self.modes.modes[self.modes.count] )

    return true
end

function Steer:client_onInteract( char, lookAt )
    if lookAt then
        self.modes.count = self.modes.count < #self.modes.modes and self.modes.count + 1 or 1
        sm.audio.play("PaintTool - ColorPick")
        self.network:sendToServer("sv_save")
    end
end