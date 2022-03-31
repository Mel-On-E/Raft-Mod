-- OilGeyser.lua --
dofile "$SURVIVAL_DATA/Scripts/game/survival_harvestable.lua"

OilGeyser = class( nil )

--Raft
OilGeyser.spawnJunk = -1

function OilGeyser.server_onCreate( self )
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = true
		self.storage:save( self.saved )
		self.spawnJunk = 10
	end
end

function OilGeyser.server_spawnJunk(self)
	for _, player in pairs(sm.player.getAllPlayers()) do
		if player.id == 1 then
			vec = self.harvestable:getPosition()
			vec.z = -2

			local random = math.random(1,1000)
			local i
			if random <= 0010 then
				vec.z = -2
				local crate = hvs_lootcrate
				if math.random(1,30) == 30 then
					crate = hvs_lootcrateepic
				end

				sm.harvestable.create( crate, vec, self.harvestable.worldRotation )
				return
			elseif random <= 0100 then
				return
			elseif random <= 0110 then
				i = 6
			elseif random <= 0125 then
				i = 5
			elseif random <= 0200 then
				i = 4
			elseif random <= 0275 then
				i = 3
			elseif random <= 0600 then
				i = 2
			else
				i = 1
			end

			local status, error = pcall( sm.creation.importFromFile( player:getCharacter():getWorld(), "$SURVIVAL_DATA/LocalBlueprints/junk" .. tostring(i) .. ".blueprint", vec ) )
		end
	end
end

function OilGeyser.server_onFixedUpdate( self, state )
	if self.spawnJunk == 0 then
		self:server_spawnJunk()
	end
	self.spawnJunk = self.spawnJunk - 1
end



function OilGeyser.client_onInteract( self, state )
	self.network:sendToServer( "sv_n_harvest" )
end

function OilGeyser.client_canInteract( self )
	sm.gui.setInteractionText( "", sm.gui.getKeyBinding( "Attack" ), "#{INTERACTION_PICK_UP}" )
	return true
end

function OilGeyser.server_canErase( self ) return true end
function OilGeyser.client_canErase( self ) return true end

function OilGeyser.server_onRemoved( self, player )
	self:sv_n_harvest( nil, player )
end

function OilGeyser.client_onCreate( self )
	self.cl = {}
	self.cl.acitveGeyser = sm.effect.createEffect( "Oilgeyser - OilgeyserLoop" )
	self.cl.acitveGeyser:setPosition( self.harvestable.worldPosition )
	self.cl.acitveGeyser:setRotation( self.harvestable.worldRotation )
	self.cl.acitveGeyser:start()
end

function OilGeyser.cl_n_onInventoryFull( self )
	sm.gui.displayAlertText( "#{INFO_INVENTORY_FULL}", 4 )
end

function OilGeyser.sv_n_harvest( self, params, player )
	if not self.harvested and sm.exists( self.harvestable ) then
		if SurvivalGame then
			local container = player:getInventory()
			local quantity = randomStackAmount( 1, 2, 4 )
			if sm.container.beginTransaction() then
				sm.container.collect( container, obj_resource_crudeoil, quantity )
				if sm.container.endTransaction() then
					sm.event.sendToPlayer( player, "sv_e_onLoot", { uuid = obj_resource_crudeoil, quantity = quantity, pos = self.harvestable.worldPosition } )
					sm.effect.playEffect( "Oilgeyser - Picked", self.harvestable.worldPosition )
					sm.harvestable.create( hvs_farmables_growing_oilgeyser, self.harvestable.worldPosition, self.harvestable.worldRotation )
					sm.harvestable.destroy( self.harvestable )
					self.harvested = true
				else
					self.network:sendToClient( player, "cl_n_onInventoryFull" )
				end
			end
		else
			sm.effect.playEffect( "Oilgeyser - Picked", self.harvestable.worldPosition )
			sm.harvestable.create( hvs_farmables_growing_oilgeyser, self.harvestable.worldPosition, self.harvestable.worldRotation )
			sm.harvestable.destroy( self.harvestable )
			self.harvested = true
		end
	end
end

function OilGeyser.client_onDestroy( self )
	self.cl.acitveGeyser:stop()
	self.cl.acitveGeyser:destroy()
end
