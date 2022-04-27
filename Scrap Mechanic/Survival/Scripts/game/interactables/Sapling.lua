dofile("$SURVIVAL_DATA/Scripts/game/survival_loot.lua")
dofile("$SURVIVAL_DATA/Scripts/game/survival_harvestable.lua")

Sapling = class()

function Sapling.server_onCreate(self)
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = {}
		valid, treePos = Sapling.check_ground(self)
		self.saved.grow = -1
		self.saved.valid, self.saved.treePos = Sapling.check_ground(self)

		self.storage:save( self.saved )
	end
	self.network:setClientData( { valid = self.saved.valid, planted = self.saved.planted } )
	
end

function Sapling.check_ground(self)
	local valid = false
	local treePos = sm.vec3.zero()
	local raycast_start = self.shape.worldPosition + sm.vec3.new(0,0,0.125)
	local raycast_end = self.shape.worldPosition + sm.vec3.new(0,0,-0.3)
	local body = sm.shape.getBody(self.shape)
	local success, result = sm.physics.raycast( raycast_start, raycast_end, body)
	if success and result.type == "terrainSurface" then
		valid = true
		treePos = result.pointWorld
	end
	return valid, treePos
end

function Sapling.client_onClientDataUpdate( self, params )
	self.valid = params.valid
	self.planted = params.planted
end

function Sapling.client_canInteract(self)
	if self.planted then
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
	
	local treePos
	valid, treePos = Sapling.check_ground(self)
	if valid then		
		sm.effect.playEffect("Cotton - Picked", treePos + sm.vec3.new(0, 0, -0.5))
		sm.effect.playEffect("Tree - LogAppear", treePos)
		
		self.saved.treePos = treePos
		self.saved.grow = math.random(40*60, 40*60*24)
		
		self.saved.planted = true
		self.storage:save( self.saved )
		self.network:setClientData( { valid = self.saved.valid, planted = self.saved.planted } )
	end
end

function Sapling:server_onFixedUpdate()

	if self.saved then
		if self.saved.grow == 0 then
			local offset = sm.vec3.new(0.375, -0.375, 0)
			sm.harvestable.create( self.tree, self.saved.treePos - offset, sm.quat.new(0.707, 0, 0, 0.707) )

			self.shape:destroyPart(0)
			return
		end
		self.saved.grow = self.saved.grow - 1
		self.storage:save( self.saved )
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