
CreativePlayer = class( nil )

local maxTankCharge = 30 --Raft

function CreativePlayer.server_onCreate( self )
	self.sv = {}

	--Raft
	self.sv.wearingTank = false
	self.sv.tankCharge = maxTankCharge
	--Raft

	self:sv_init()
end

function CreativePlayer.server_onRefresh( self )
	self:sv_init()
end

function CreativePlayer.sv_init( self ) end

function CreativePlayer.server_onDestroy( self ) end

function CreativePlayer.client_onCreate( self )
	self.cl = {}

	--Raft
	self.cl.checkFins = true
	self.cl.checkTank = true
	--Raft

	self:cl_init()

	self:cl_checkFinRenderable({ char = sm.localPlayer.getPlayer():getCharacter(), inv = sm.localPlayer.getHotbar() }) --Raft
end

function CreativePlayer.client_onRefresh( self )
	self:cl_init()
end

function CreativePlayer.cl_init(self) end

function CreativePlayer.client_onUpdate( self, dt )
	--Raft
	local player = sm.localPlayer.getPlayer()
	local character = player:getCharacter()
	if character == nil then return end
	local inv = sm.game.getLimitedInventory() and sm.localPlayer.getInventory() or sm.localPlayer.getHotbar()

	self.network:sendToServer("sv_checkRenderables", { player = player, char = character, inv = inv, checkFins = self.cl.checkFins, checkTank = self.cl.checkTank })

	local speed = sm.container.canSpend( inv, obj_fins, 1 ) and (character:isSwimming() or character:isDiving()) and 2 or 1
	if character:getMovementSpeedFraction() ~= speed then
		self.network:sendToServer("sv_setMoveSpeed", { char = character, speed = speed })
	end
end

function CreativePlayer:sv_setMoveSpeed( args )
	args.char:setMovementSpeedFraction(args.speed)
end

function CreativePlayer:sv_checkRenderables( args )
	local hasChanged = args.inv:hasChanged( sm.game.getCurrentTick() - 1 )

	if hasChanged or args.checkFins then
		self.network:sendToClients("cl_checkFinRenderable", { wornBy = args.player, char = args.char, inv = args.inv })
	end

	if hasChanged or args.checkTank then
		self.sv.wearingTank = sm.container.canSpend( args.inv, obj_oxygen_tank, 1 )

		self.network:sendToClients("cl_checkTankRenderable", { wornBy = args.player, char = args.char, inv = args.inv })
	end
end

function CreativePlayer:cl_checkFinRenderable( args )
	if sm.container.canSpend( args.inv, obj_fins, 1 ) then
		args.char:addRenderable( "$SURVIVAL_DATA/RaftMod/Character/Char_player/Flipper/obj_fins.rend" )
	else
		args.char:removeRenderable( "$SURVIVAL_DATA/RaftMod/Character/Char_player/Flipper/obj_fins.rend" )
	end

	if args.wornBy == sm.localPlayer.getPlayer() then
		self.cl.checkFins = false
	end
end

function CreativePlayer:cl_checkTankRenderable( args )
	if sm.container.canSpend( args.inv, obj_oxygen_tank, 1 ) then
		args.char:addRenderable( "$SURVIVAL_DATA/RaftMod/Character/Char_player/AirTank/Airtank.rend" )
	else
		args.char:removeRenderable( "$SURVIVAL_DATA/RaftMod/Character/Char_player/AirTank/Airtank.rend" )
	end

	if args.wornBy == sm.localPlayer.getPlayer() then
		self.cl.checkTank = false
	end
end
--Raft

function CreativePlayer.client_onInteract( self, character, state ) end

function CreativePlayer.server_onFixedUpdate( self, dt ) end

function CreativePlayer.server_onProjectile( self, hitPos, hitTime, hitVelocity, projectileName, attacker, damage ) end

function CreativePlayer.server_onMelee( self, hitPos, attacker, damage, power )
	if not sm.exists( attacker ) then
		return
	end

	if self.player.character and attacker.character then
		local attackDirection = ( hitPos - attacker.character.worldPosition ):normalize()
		-- Melee impulse
		if attacker then
			ApplyKnockback( self.player.character, attackDirection, power )
		end
	end
end

function CreativePlayer.server_onExplosion( self, center, destructionLevel ) end

function CreativePlayer.server_onCollision( self, other, collisionPosition, selfPointVelocity, otherPointVelocity, collisionNormal  ) end

function CreativePlayer.sv_e_staminaSpend( self, stamina ) end

function CreativePlayer.sv_e_receiveDamage( self, damageData ) end

function CreativePlayer.sv_e_respawn( self ) end

function CreativePlayer.sv_e_debug( self, params ) end

function CreativePlayer.sv_e_eat( self, edibleParams ) end

function CreativePlayer.sv_e_feed( self, params ) end

function CreativePlayer.sv_e_setRefiningState( self, params )
	local userPlayer = params.user:getPlayer()
	if userPlayer then
		if params.state == true then
			userPlayer:sendCharacterEvent( "refine" )
		else
			userPlayer:sendCharacterEvent( "refineEnd" )
		end
	end
end

function CreativePlayer.sv_e_onLoot( self, params ) end

function CreativePlayer.sv_e_onStayPesticide( self ) end

function CreativePlayer.sv_e_onEnterFire( self ) end

function CreativePlayer.sv_e_onStayFire( self ) end

function CreativePlayer.sv_e_onEnterChemical( self ) end

function CreativePlayer.sv_e_onStayChemical( self ) end

function CreativePlayer.sv_e_startLocalCutscene( self, cutsceneInfoName ) end

function CreativePlayer.client_onCancel( self ) end

function CreativePlayer.client_onReload( self ) end

function CreativePlayer.server_onShapeRemoved( self, removedShapes ) end