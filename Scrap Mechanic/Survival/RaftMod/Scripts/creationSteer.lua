Steer = class()
Steer.maxChildCount = -1
Steer.maxParentCount = 2
Steer.connectionInput = sm.interactable.connectionType.power + sm.interactable.connectionType.logic
Steer.connectionOutput = sm.interactable.connectionType.logic
Steer.colorNormal = sm.color.new("#00ff33")
Steer.colorHighlight = sm.color.new("#00ff00")

local modes = {
    "Vertical + Horizontal",
    "Vertical",
    "Horizontal",
    "Roll"
}

local maxForceMult = 25

function Steer:server_onCreate()
    self.data = self.storage:load()

    if self.data == nil then
        self.data = {
            count = 1,
            slider = 1
        }
    end
end

function Steer:client_onCreate()
    self.gui = sm.gui.createEngineGui()
    self.gui:setText( "Name", "Creation Rotator" )
	self.gui:setText( "Interaction", "Force multiplier" )
	self.gui:setSliderCallback( "Setting", "cl_onSliderChange" )
	self.gui:setIconImage( "Icon", obj_creationSteer )

    self:cl_refreshGUI()
end

function Steer:cl_refreshGUI()
	self.gui:setSliderData( "Setting", maxForceMult + 1, self.data.slider )
	self.gui:setText( "SubTitle", "Multiplier: " .. tostring( self.data.slider ) )
end

function Steer:cl_onSliderChange( sliderName, sliderPos )
    self:cl_refreshGUI()
    self.network:sendToServer("sv_onSliderChange", sliderPos)
end

function Steer:sv_onSliderChange( sliderPos )
    self.data.slider = sliderPos
    self:sv_save()
end

function Steer:server_onFixedUpdate( dt )
    local logicParent = self.interactable:getParents( sm.interactable.connectionType.logic )[1]
    local seatParent = self.interactable:getParents( sm.interactable.connectionType.power )[1]
    if not seatParent or logicParent and not logicParent:isActive() then
        self:sv_updateState( { active = false, power = 0, index = 1  } )
        return
    end

    local seatedChar = seatParent:getSeatCharacter()
    if not seatedChar then
        self:sv_updateState( { active = false, power = 0, index = 1  } )
        return
    end

    local charDir = seatedChar:getDirection()
    local parentShape = seatParent:getShape()
    local parentDir = parentShape:getRight():cross(parentShape:getAt()) --a seat's getAt is upwards, I want a forward direction
    local forceDir = parentDir:cross(charDir)
    --self.network:sendToClients("cl_visualise", { charDir, parentDir, forceDir })

    local bodyToRotate = parentShape:getBody()
    local creationMass = 0
    for v, k in pairs(self.shape:getBody():getCreationShapes()) do
        creationMass = creationMass + k:getBody():getMass()
    end

    local selectedMode = modes[self.data.count]
    if selectedMode == modes[2] then
        forceDir.z = 0
    elseif selectedMode == modes[3] then
        forceDir.y = 0
    elseif selectedMode == modes[4] then
        forceDir.y = 0
        forceDir.z = 0
        forceDir = parentDir * seatParent:getSteeringAngle()
    end

    sm.physics.applyTorque( bodyToRotate, forceDir * (creationMass / 2.5) * dt * self.data.slider, true )
    if not self.interactable:isActive() then
        self:sv_updateState( { active = true, power = 1, index = 7 } )
    end
end

function Steer.client_getAvailableParentConnectionCount( self, connectionType )
	if bit.band( connectionType, sm.interactable.connectionType.logic ) ~= 0 then
		return 1 - #self.interactable:getParents( sm.interactable.connectionType.logic )
	end
	if bit.band( connectionType, sm.interactable.connectionType.power ) ~= 0 then
		return 1 - #self.interactable:getParents( sm.interactable.connectionType.power )
	end
	return 0
end

function Steer:cl_visualise( dir )
    for v, k in pairs(dir) do
        sm.particle.createParticle( "paint_smoke", self.shape:getWorldPosition() + k, sm.quat.identity(), sm.color.new(v/10, v/10, v/10) )
    end
end

function Steer:sv_updateState( args )
    self.interactable:setActive( args.active )
    self.interactable:setPower( args.power )

    self.network:sendToClients("cl_uvUpdate", args.index)
end

function Steer:sv_save()
    self.storage:save( self.data )
end

function Steer:cl_uvUpdate( index )
    self.interactable:setUvFrameIndex( index )
end

function Steer:client_canInteract()
	sm.gui.setInteractionText( "", "Current mode: #df7f00"..modes[self.data.count] )
    sm.gui.setInteractionText( "", "'"..sm.gui.getKeyBinding( "Use" ).."' to cycle forwards, '"..sm.gui.getKeyBinding( "Crawl" ).."' + '"..sm.gui.getKeyBinding( "Use" ).."' to cycle backwards and '"..sm.gui.getKeyBinding( "Tinker" ).."' to adjust the force multiplier." )

    return true
end

function Steer:client_onInteract( char, lookAt )
    if lookAt then
        if char:isCrouching() then
            self.data.count = self.data.count > 1 and self.data.count - 1 or #modes
        else
            self.data.count = self.data.count < #modes and self.data.count + 1 or 1
        end

        sm.audio.play("PaintTool - ColorPick")
        self.network:sendToServer("sv_save")
    end
end

function Steer:client_onTinker( char, lookAt )
    if lookAt then
        self:cl_refreshGUI()
        self.gui:open()
    end
end