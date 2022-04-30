-- Chest.lua --
dofile "$SURVIVAL_DATA/Scripts/game/survival_items.lua"
dofile "$SURVIVAL_DATA/Scripts/game/survival_loot.lua"

Chest = class( nil )

local function addToTable(t1,t2)
    for _,v in ipairs(t2) do 
        table.insert(t1, v)
    end
end

function Chest.server_onCreate( self )
	local container = self.shape.interactable:getContainer( 0 )
    if not container then
		container = self.shape:getInteractable():addContainer( 0, 20, 256 )
	end
	
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = 0

        for _, body in pairs(self.shape:getBody():getCreationBodies()) do
            body:setDestructable(false)
            body:setPaintable(false)
            body:setConnectable(false)
            body:setLiftable(false)
            body:setErasable(false)

            self.saved = self.saved + body:getMass()
        end 

        local loot = {}
        addToTable(loot, SelectLoot("loot_ruinchest", 20))
        addToTable(loot, SelectLoot("loot_ruinchest", 20))
        addToTable(loot, SelectLoot("loot_ruinchest", 20))
        addToTable(loot, SelectLoot("loot_ruinchest_startarea", 20))
        addToTable(loot, SelectLoot("loot_crate_standard", 20))
        addToTable(loot, SelectLoot("loot_crate_standard", 20))
        addToTable(loot, SelectLoot("loot_crate_epic", 20))

        if sm.container.beginTransaction() then
            if math.random(1,10) < 7 then
                sm.container.collect( container, obj_consumable_soilbag, math.random(1,3), false )
            end
            for _, item in pairs(loot) do
                sm.container.collect( container, item.uuid, item.quantity, false )
            end
            sm.container.endTransaction()
        end

        container.allowSpend = true
	    container.allowCollect = false
	end
	self.storage:save( self.saved )
end

function Chest.client_onDestroy( self )
	if self.cl.containerGui then
		if sm.exists( self.cl.containerGui ) then
			self.cl.containerGui:close()
			self.cl.containerGui:destroy()
		end
	end
end

function Chest.server_onFixedUpdate( self )
	local container = self.shape.interactable:getContainer( 0 )
	if container then
		if self.sink then
            local down = sm.vec3.new(0,0,-1)
            local force = (sm.game.getCurrentTick() - self.sink) / 2500
            sm.physics.applyImpulse(self.shape:getBody(), down*force*self.saved, true)

            if self.shape:getBody().worldPosition.z < -5 and self.shape:getBody():getVelocity().z > -0.01 then
                for _, shape in pairs(self.shape:getBody():getCreationShapes()) do
                    sm.shape.destroyShape(shape, 0)
                end 
            end
		end
	end
end

function Chest.client_onCreate( self )
	if self.cl == nil then
		self.cl = {}
	end
end

function Chest.client_onInteract( self, character, state )
	if state == true then
		local container = self.shape.interactable:getContainer( 0 )
		if container then
			self.cl.containerGui = sm.gui.createContainerGui( true )
			self.cl.containerGui:setText( "UpperName", "#{CHEST_TITLE_CHEST}" )
			self.cl.containerGui:setVisible( "ChestIcon", false )
			self.cl.containerGui:setVisible( "ChestIcon", true )
			self.cl.containerGui:setContainer( "UpperGrid", container );
			self.cl.containerGui:setText( "LowerName", "#{INVENTORY_TITLE}" )
			self.cl.containerGui:setContainer( "LowerGrid", sm.localPlayer.getInventory() )
			self.cl.containerGui:open()
            if not self.sink then
                self.sink = sm.game.getCurrentTick()
            end
		end
	end
end

function Chest.client_canInteract( self )
	return true
end