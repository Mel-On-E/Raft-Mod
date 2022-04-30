dofile("$SURVIVAL_DATA/Scripts/game/survival_loot.lua")
dofile("$SURVIVAL_DATA/Scripts/game/survival_harvestable.lua")

Sapling = class()

function Sapling.server_onCreate(self)
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = {}
		self.caculatingBox = true
	end

	self:server_clientDataUpdate()
end

function Sapling.client_onCreate(self)
	self.caculating = true -- default true!
end

function Sapling.check_ground(self)
	local valid = false
	local treePos = sm.vec3.zero()
	local raycast_start = self.shape.worldPosition + sm.vec3.new(0,0,0.125)
	local raycast_end = self.shape.worldPosition + sm.vec3.new(0,0,-0.3)
	local body = sm.shape.getBody(self.shape)
	local success, result = sm.physics.raycast( raycast_start, raycast_end, body)
	
	local isInWater = false
    for _, result in ipairs( self.boundingBox:getContents() ) do
        if sm.exists( result ) then
            local userData = result:getUserData()
            if userData and userData.water then
                isInWater = true
            end
        end
    end

	if success and result.type == "terrainSurface" and not isInWater  then
		valid = true
		treePos = result.pointWorld
	end
	return valid, treePos
end

function Sapling.server_clientDataUpdate( self )
	self.network:setClientData( { valid = self.saved.valid or false, planted = self.saved.planted or false, caculating = self.caculatingBox } )
end

function Sapling.client_onClientDataUpdate( self, params )
	self.caculating = params.caculating
	self.valid = params.valid
	self.planted = params.planted
end

function Sapling.client_canInteract(self)
	if self.caculating then
		sm.gui.setInteractionText("", "Caculating...")
	elseif self.planted then
		sm.gui.setInteractionText("", "Growing...")
	elseif self.valid then
		sm.gui.setInteractionText("Splash with", "Water")
	else
		sm.gui.setInteractionText("Place on the", "#ff0000Surface")
	end
	return true
end

function Sapling.server_onProjectile( self, hitPos, hitTime, hitVelocity, projectileName, attacker, damage )
	local valid = false

	if projectileName == "water" then 
		valid = true 
	end
	
	if self.planted then valid = false end
	
	if not valid then return end
	
	local valid, treePos = Sapling.check_ground(self)
	if valid then		
		sm.effect.playEffect("Cotton - Picked", treePos + sm.vec3.new(0, 0, -0.5))
		sm.effect.playEffect("Tree - LogAppear", treePos)
		
		self.saved.treePos = treePos
		self.saved.grow = math.random(60, 60*24) -- in seconds
		
		self.saved.planted = true
		self.storage:save( self.saved )
		self.network:setClientData( { valid = self.saved.valid, planted = self.saved.planted } )
		
		-- destroy bounding box
		sm.areaTrigger.destroy( self.boundingBox )
	end
end

function Sapling:server_onFixedUpdate()
	if self.saved and sm.game.getCurrentTick() % (40 * 5) == 0 then
		if self.saved.grow == 0 then
			local offset = sm.vec3.new(0.375, -0.375, 0)
			sm.harvestable.create( self.tree, self.saved.treePos - offset, sm.quat.new(0.707, 0, 0, 0.707) )

			self.shape:destroyPart(0)
			return
		end
		self.saved.grow = self.saved.grow - 5 -- five seconds per call
		self.storage:save( self.saved )
	end

	if self.caculatingBox and sm.game.getCurrentTick() % 6 == 0 then 
		if self.boundingBox == nil then
			self.boundingBox = sm.areaTrigger.createAttachedBox( self.interactable, sm.vec3.one() / 4, sm.vec3.zero(), sm.quat.identity(), sm.areaTrigger.filter.areaTrigger )
			return -- return so box can caculate its contents.
		end

		self.saved.grow = -1
		self.saved.valid, self.saved.treePos = Sapling.check_ground(self)

		self.storage:save( self.saved )
		self.network:setClientData( { valid = self.saved.valid, planted = self.saved.planted } )

		self.caculatingBox = false
	end	
end

BirchSapling = class( Sapling )
BirchSapling.tree = hvs_tree_birch01

LeafySapling = class( Sapling )
LeafySapling.tree = hvs_tree_leafy01

SpruceSapling = class( Sapling )
SpruceSapling.tree = hvs_tree_spruce01

PineSapling = class( Sapling )
PineSapling.tree = hvs_tree_pine01