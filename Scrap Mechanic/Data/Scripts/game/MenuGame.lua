dofile( "$SURVIVAL_DATA/Scripts/game/managers/UnitManager.lua" )

MenuGame = class( nil )
MenuGame.enableLimitedInventory = false
MenuGame.enableRestrictions = false
MenuGame.enableFuelConsumption = false
MenuGame.enableAmmoConsumption = false
MenuGame.enableUpgradeCost = false

g_godMode = true

-- Game Server side --

function MenuGame.server_onCreate( self )
	local worldScriptFilename = "$GAME_DATA/Scripts/game/worlds/MenuWorld.lua"
	local worldScriptClass = "MenuWorld"
	self.menuWorld = sm.world.createWorld( worldScriptFilename, worldScriptClass )
	sm.game.bindChatCommand( "/save", {}, "sv_onChatCommand", "Save the menu creation" )

	g_unitManager = UnitManager()
	g_unitManager:sv_onCreate( nil )
end

function MenuGame.server_onFixedUpdate( self, timeStep )
	g_unitManager:sv_onFixedUpdate()
 end

function MenuGame.server_onPlayerJoined( self, player, newPlayer )
	print( player.name, "joined the game" )
	g_unitManager:sv_onPlayerJoined( player )
	if not sm.exists( self.menuWorld ) then
		sm.world.loadWorld( self.menuWorld )
	end
	self.menuWorld:loadCell( 2, 0, player, "sv_cellLoaded" )
end

function MenuGame.sv_cellLoaded( self, world, x, y, player )
	local params = { player = player, x = x, y = y }
	sm.event.sendToWorld( world, "sv_e_spawnNewCharacter", params )
end

-- Game Client side --

function MenuGame.client_onCreate( self )
	sm.game.setTimeOfDay( 0.5 )
	sm.render.setOutdoorLighting( 0.5 )
end