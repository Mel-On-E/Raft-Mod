dofile( "$SURVIVAL_DATA/Scripts/game/managers/UnitManager.lua" )
dofile( "$SURVIVAL_DATA/Scripts/game/managers/PesticideManager.lua" )
dofile( "$SURVIVAL_DATA/Scripts/game/survival_harvestable.lua" )

CreativeBaseWorld = class( nil )

local PotatoProjectiles = { "potato", "smallpotato", "fries" }

function CreativeBaseWorld.server_onCreate( self )
	self.pesticideManager = PesticideManager()
	self.pesticideManager:sv_onCreate()

	--Raft
	--self.spearStuff = self.storage:load()
	--if self.spearStuff == nil then
		self.spearStuff = {
			spears = {},
			effects = {}
		}
	--end

	self.network:sendToClients("cl_setEffects", self.spearStuff.spears)
	--Raft
end

--Raft
function CreativeBaseWorld:cl_setEffects( args )
	for v, k in pairs(args) do
		self.effects[#self.effects+1] = sm.effect.createEffect("ShapeRenderable")
		local effect = self.effects[#self.effects]

		effect:setParameter("uuid", sm.uuid.new("4a971f7d-14e6-454d-bce8-0879243c4857"))
		effect:setParameter("color", sm.color.new(0.4,0.4,0.4))
		effect:setScale( sm.vec3.new(0.12,0.12,0.3) )
		effect:setPosition( k.pos )
		effect:setRotation( sm.vec3.getRotation( sm.vec3.new( 0, 0, 1 ), k.dir ) )
		effect:start()
	end
end

function CreativeBaseWorld:sv_shootSpear( args )
	local spear = { effect = nil, owner = args.owner, speed = sm.vec3.one() * 0.75, trigger = nil, pos = args.pos, dir = args.dir, lifeTime = 0, attached = false, attachedTarget = nil, attachPos = sm.vec3.zero(), attachDir = sm.vec3.zero() }
	spear.trigger = sm.areaTrigger.createBox( sm.vec3.new(0.25,0.25,0.25), spear.pos + spear.dir, sm.quat.identity() )

	local effectData = { effect = spear.effect, pos = args.pos, dir = args.dir }
	self.spearStuff.effects[#self.spearStuff.effects+1] = effectData
	self.network:sendToClients("cl_shootSpear", effectData)

	self.spearStuff.spears[#self.spearStuff.spears+1] = spear

	--self.storage:save( self.spearStuff )
end

function CreativeBaseWorld:cl_shootSpear( args )
	self.effects[#self.effects+1] = sm.effect.createEffect("ShapeRenderable")
	local effect = self.effects[#self.effects]

	effect:setParameter("uuid", sm.uuid.new("4a971f7d-14e6-454d-bce8-0879243c4857"))
	effect:setParameter("color", sm.color.new(0.4,0.4,0.4))
	effect:setScale( sm.vec3.new(0.12,0.12,0.3) )
	effect:setPosition( args.pos )
	effect:setRotation( sm.vec3.getRotation( sm.vec3.new( 0, 0, 1 ), args.dir ) )
	effect:start()
end

function CreativeBaseWorld:sv_spearCollect( args )
	local inv = args.player:getInventory()
	self.network:sendToClient(args.player, "cl_spearCollect")

	sm.container.beginTransaction()
	sm.container.collect( inv, obj_arrow, 1, 1 )
	sm.container.endTransaction()
end

function CreativeBaseWorld:cl_spearCollect()
	sm.audio.play( "Sledgehammer - Swing" )
	sm.gui.displayAlertText( "#{RAFT_PICKUP_HARPOON}", 2.5)
end
--Raft

function CreativeBaseWorld.client_onCreate( self )
    if self.pesticideManager == nil then
		assert( not sm.isHost )
		self.pesticideManager = PesticideManager()
	end
	self.pesticideManager:cl_onCreate()

	--Raft
	self.effects = {}
	--Raft
end

function CreativeBaseWorld.server_onFixedUpdate( self )
	self.pesticideManager:sv_onWorldFixedUpdate( self )

	local Damage = 69
	local spearImpact = 2.5
	local dt = 0.025 --bruh

	--Raft
	if #self.spearStuff.spears == 0 then return end

	for tablePos, spear in pairs(self.spearStuff.spears) do
		if spear.lifeTime >= 30 then
			self:sv_spearCollect( { player = spear.owner, index = tablePos } )
			self.spearStuff.spears[tablePos] = nil
		else
			if spear.trigger ~= nil and sm.exists(spear.trigger) then
				local pos = spear.attached and spear.pos or spear.pos + spear.dir
				local scale = spear.attached and sm.vec3.one() or sm.vec3.new(0.25,0.25,0.25)
				spear.trigger:setSize( scale )
				spear.trigger:setWorldPosition( pos )
			end

			local alive = true
			for _, content in ipairs( spear.trigger:getContents() ) do
				local obj = content
				if sm.exists( obj ) then
					if type(obj) == "Character" and obj:isPlayer() then
						self:sv_spearCollect( { player = obj:getPlayer(), index = tablePos } )
						--self.spearStuff.spears[tablePos] = nil
						spear.lifeTime = 31
						alive = false
						break
					end
				end
			end

			if alive then
				if not spear.attached then
					local hit, result = sm.physics.raycast( spear.pos, spear.pos + spear.dir * 2 )
					if result.type == "terrainSurface" or result.type == "terrainAsset" then
						spear.attached = true
					elseif result.type == "character" and not result:getCharacter():isPlayer() then
						spear.attached = true
						spear.attachedTarget = result:getCharacter()
						spear.attachPos = result.pointLocal
						spear.attachDir = spear.dir

						sm.event.sendToUnit(spear.attachedTarget:getUnit(), "sv_raft_takeDamage", { damage = Damage, impact = spear.dir * spearImpact, hitPos = spear.attachPos })
					elseif result.type == "body" then
						spear.attached = true
						spear.attachedTarget = result:getBody()
						spear.attachPos = result.pointLocal
						spear.attachDir = spear.dir
					end

					spear.lifeTime = spear.lifeTime + dt

					local inWater = false
					if sm.exists(spear.trigger) then
						for _, result in ipairs( spear.trigger:getContents() ) do
							if sm.exists( result ) then
								if type(result) == "AreaTrigger" then
									local userData = result:getUserData()
									if userData and userData.water then
										inWater = true

										local reductionMult = inWater and 0.25 or 1
										if spear.speed > sm.vec3.one() / 10 and spear.lifeTime > 0.5 then
											spear.speed = spear.speed - sm.vec3.one() / 5 * reductionMult * dt
										end
									end
								end
							end
						end
					end

					if spear.dir.z > -1 then
						local gravity = inWater and sm.vec3.new(0,0,0.000005) or sm.vec3.new(0,0,0.005)
						spear.dir = spear.dir - gravity / spear.speed
					end

					local newPos = spear.pos + spear.speed * spear.dir * dt * 50
					spear.pos = newPos
				else
					local hit, result = sm.physics.raycast( spear.pos - spear.dir, spear.pos + spear.dir * 2 ) --this is shit
					local attachedCheck = spear.attachedTarget
					if type(spear.attachedTarget) == "Character" then
						attachedCheck = result:getCharacter()
					elseif type(spear.attachedTarget) == "Body" then
						attachedCheck = result:getBody()
					end

					if result:getCharacter() and result:getCharacter():isPlayer() then
						attachedCheck = spear.attachedTarget
					end

					if spear.attachedTarget == nil then

					elseif spear.attachedTarget ~= attachedCheck or not sm.exists(spear.attachedTarget) then
						spear.attached = false
						spear.attachedTarget = nil
						spear.speed = sm.vec3.one() / 10
						spear.dir.z = -1
					else
						if type(spear.attachedTarget) == "Body" then
							spear.pos = spear.attachedTarget:transformPoint(spear.attachPos)
							spear.dir = sm.body.getWorldRotation(spear.attachedTarget) * spear.attachDir
						elseif type(spear.attachedTarget) == "Character" then
							spear.pos = spear.attachedTarget:getWorldPosition()
							spear.dir = spear.attachedTarget:getDirection() * spear.attachDir
						end
					end
				end
			end
		end
	end

	local effects = {}
	for v, k in pairs(self.spearStuff.spears) do
		effects[#effects+1] = { effect = k.effect, pos = k.pos, dir = k.dir }
	end

	self.network:sendToClients("cl_drawEffects", effects)
	--self.storage:save(self.spearStuff)
end

function CreativeBaseWorld:cl_drawEffects( effects )
	for tablePos, effect in pairs(self.effects) do
		local effectData = effects[tablePos]
		if sm.exists(effect) then
			if effectData ~= nil then
				effect:setPosition( effectData.pos )
				effect:setRotation( sm.vec3.getRotation( sm.vec3.new( 0, 0, 1 ), effectData.dir ) )
			else
				self.effects[tablePos]:stop()
				self.effects[tablePos] = nil
			end
		end
	end
end
--Raft

function CreativeBaseWorld.cl_n_pesticideMsg( self, msg )
	self.pesticideManager[msg.fn]( self.pesticideManager, msg )
end

function CreativeBaseWorld.server_onProjectileFire( self, firePos, fireVelocity, projectileName, attacker )
	if isAnyOf( projectileName, PotatoProjectiles ) then
		local units = sm.unit.getAllUnits()
		for i, unit in ipairs( units ) do
			if InSameWorld( self.world, unit ) then
				sm.event.sendToUnit( unit, "sv_e_worldEvent", { eventName = "projectileFire", firePos = firePos, fireVelocity = fireVelocity, projectileName = projectileName, attacker = attacker })
			end
		end
	end
end

function CreativeBaseWorld.server_onInteractableCreated( self, interactable )
	g_unitManager:sv_onInteractableCreated( interactable )
end

function CreativeBaseWorld.server_onInteractableDestroyed( self, interactable )
	g_unitManager:sv_onInteractableDestroyed( interactable )
end

function CreativeBaseWorld.server_onProjectile( self, hitPos, hitTime, hitVelocity, projectileName, attacker, damage, userData )
    -- Notify units about projectile hit
    if isAnyOf( projectileName, PotatoProjectiles ) then
		local units = sm.unit.getAllUnits()
		for i, unit in ipairs( units ) do
			if InSameWorld( self.world, unit ) then
				sm.event.sendToUnit( unit, "sv_e_worldEvent", { eventName = "projectileHit", hitPos = hitPos, hitTime = hitTime, hitVelocity = hitVelocity, attacker = attacker, damage = damage })
			end
		end
	end

	if projectileName == "pesticide" then
		local forward = sm.vec3.new( 0, 1, 0 )
		local randomDir = forward:rotateZ( math.random( 0, 359 ) )
		local effectPos = hitPos
		local success, result = sm.physics.raycast( hitPos + sm.vec3.new( 0, 0, 0.1 ), hitPos - sm.vec3.new( 0, 0, PESTICIDE_SIZE.z * 0.5 ), nil, sm.physics.filter.static + sm.physics.filter.dynamicBody )
		if success then
			effectPos = result.pointWorld + sm.vec3.new( 0, 0, PESTICIDE_SIZE.z * 0.5 )
		end
		self.pesticideManager:sv_addPesticide( self, effectPos, sm.vec3.getRotation( forward, randomDir ) )
	end

	if projectileName == "glowstick" then
		sm.harvestable.create( hvs_remains_glowstick, hitPos, sm.vec3.getRotation( sm.vec3.new( 0, 1, 0 ), hitVelocity:normalize() ) )
	end

	if projectileName == "explosivetape" then
		sm.physics.explode( hitPos, 7, 2.0, 6.0, 25.0, "RedTapeBot - ExplosivesHit" )
	end
end

function CreativeBaseWorld.server_onCollision( self, objectA, objectB, collisionPosition, objectAPointVelocity, objectBPointVelocity, collisionNormal )
	g_unitManager:sv_onWorldCollision( self, objectA, objectB, collisionPosition, objectAPointVelocity, objectBPointVelocity, collisionNormal )
end

function CreativeBaseWorld.sv_e_clear( self )
	for _, body in ipairs( sm.body.getAllBodies() ) do
		for _, shape in ipairs( body:getShapes() ) do
			shape:destroyShape()
		end
	end
end

local function selectHarvestableToPlace( keyword )
	if keyword == "stone" then
		local stones = {
			hvs_stone_small01, hvs_stone_small02, hvs_stone_small03
			--hvs_stone_medium01, hvs_stone_medium02, hvs_stone_medium03,
			--hvs_stone_large01, hvs_stone_large02, hvs_stone_large03
		}
		return stones[math.random( 1, #stones )]
	elseif keyword == "tree" then
		local trees = {
			hvs_tree_birch01, hvs_tree_birch02, hvs_tree_birch03,
			hvs_tree_leafy01, hvs_tree_leafy02, hvs_tree_leafy03,
			hvs_tree_spruce01, hvs_tree_spruce02, hvs_tree_spruce03,
			hvs_tree_pine01, hvs_tree_pine02, hvs_tree_pine03
		}
		return trees[math.random( 1, #trees )]
	elseif keyword == "birch" then
		local trees = { hvs_tree_birch01, hvs_tree_birch02, hvs_tree_birch03 }
		return trees[math.random( 1, #trees )]
	elseif keyword == "leafy" then
		local trees = { hvs_tree_leafy01, hvs_tree_leafy02, hvs_tree_leafy03 }
		return trees[math.random( 1, #trees )]
	elseif keyword == "spruce" then
		local trees = {	hvs_tree_spruce01, hvs_tree_spruce02, hvs_tree_spruce03 }
		return trees[math.random( 1, #trees )]
	elseif keyword == "pine" then
		local trees = { hvs_tree_pine01, hvs_tree_pine02, hvs_tree_pine03 }
		return trees[math.random( 1, #trees )]
	end
	return nil
end

function CreativeBaseWorld.sv_e_onChatCommand( self, params )
	if params[1] == "/aggroall" then
		local units = sm.unit.getAllUnits()
		for _, unit in ipairs( units ) do
			sm.event.sendToUnit( unit, "sv_e_receiveTarget", { targetCharacter = params.player.character } )
		end
		sm.gui.chatMessage( "Hostiles received " .. params.player:getName() .. "'s position." )
	elseif params[1] == "/killall" then
		local units = sm.unit.getAllUnits()
		for _, unit in ipairs( units ) do
			unit:destroy()
		end
	elseif params[1] == "/place" then
		local harvestableUuid = selectHarvestableToPlace( params[2] )
		if harvestableUuid and params.aimPosition then
			local from = params.aimPosition + sm.vec3.new( 0, 0, 16.0 )
			local to = params.aimPosition - sm.vec3.new( 0, 0, 16.0 )
			local success, result = sm.physics.raycast( from, to, nil, sm.physics.filter.default )
			if success and result.type == "terrainSurface" then
				local placeDirection = sm.vec3.new( 1, 0, 0 )
				placeDirection = placeDirection:rotateY( math.random( 0, 359 ) )
				local harvestableYZRotation = sm.vec3.getRotation( sm.vec3.new( 0, 1, 0 ), sm.vec3.new( 0, 0, 1 ) )
				local harvestableRotation = sm.quat.lookRotation( placeDirection, sm.vec3.new( 0, 1, 0 ) )
				local placePosition = result.pointWorld
				if params[2] == "stone" then
					placePosition = placePosition + sm.vec3.new( 0, 0, 2.0 )
				end
				sm.harvestable.create( harvestableUuid, placePosition, harvestableYZRotation * harvestableRotation )
			end
		end
	end
end