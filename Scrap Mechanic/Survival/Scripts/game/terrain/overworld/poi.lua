----------------------------------------------------------------------------------------------------
-- Data
----------------------------------------------------------------------------------------------------

local g_poiTiles = {}

function initPoiTiles()
	-- Add new variations at the end if lists for old world compability.
	
	-- Starting area
	g_poiTiles[POI_CRASHSITE_AREA] = {
		addPoiTile( POI_CRASHSITE_AREA, 1, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_CrashedShip_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 2, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_CrashedTower_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 3, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_BigRuin_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 4, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_CrashedTowerCliff_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 5, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_SmallRuin_A_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 6, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_SmallRuin_B_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 7, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_SmallRuin_C_01.tile" ),
		addPoiTile( POI_CRASHSITE_AREA, 8, "$SURVIVAL_DATA/Terrain/Tiles/start_area/SurvivalStartArea_SmallRuin_D_01.tile" ),
	}

	-- Unique (MEADOW)
	g_poiTiles[POI_HIDEOUT_XL] = {
		addPoiTile( POI_HIDEOUT_XL, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Hideout_512_01.tile" )
	}
	g_poiTiles[POI_SILODISTRICT_XL] = {
		addPoiTile( POI_SILODISTRICT_XL, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/SiloDistrict_512_01.tile" )
	}
	g_poiTiles[POI_RUINCITY_XL] = {
		addPoiTile( POI_RUINCITY_XL, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/RuinCity_512_01.tile" )
	}
	g_poiTiles[POI_CRASHEDSHIP_LARGE] = {
		addPoiTile( POI_CRASHEDSHIP_LARGE, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CrashedShip_256_01.tile" )
	}
	g_poiTiles[POI_CAMP_LARGE] = {
		addPoiTile( POI_CAMP_LARGE, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_WaterFront_256_01.tile" )
	}
	g_poiTiles[POI_CAPSULESCRAPYARD_MEDIUM] = {
		addPoiTile( POI_CAPSULESCRAPYARD_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/SleepCapsuleBurial_128_01.tile" )
	}
	g_poiTiles[POI_LABYRINTH_MEDIUM] = {
		addPoiTile( POI_LABYRINTH_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/HayBaleLabyrinth_128_01.tile" )
	}

	-- Special (MEADOW)
	g_poiTiles[POI_MECHANICSTATION_MEDIUM] = {
		addPoiTile( POI_MECHANICSTATION_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/MechanicStation_128_01.tile" )
	}
	g_poiTiles[POI_PACKINGSTATIONVEG_MEDIUM] = {
		addPoiTile( POI_PACKINGSTATIONVEG_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/PackingStation_Vegetable_128_01.tile" )
	}
	g_poiTiles[POI_PACKINGSTATIONFRUIT_MEDIUM] = {
		addPoiTile( POI_PACKINGSTATIONFRUIT_MEDIUM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/PackingStation_Fruit_128_01.tile" )
	}

	-- Large Random
	g_poiTiles[POI_WAREHOUSE2_LARGE] = {
		addPoiTile( POI_WAREHOUSE2_LARGE, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Warehouse_Exterior_2Floors_256_01.tile" ),
		addPoiTile( POI_WAREHOUSE2_LARGE, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Warehouse_Exterior_2Floors_256_02.tile" ),
		addPoiTile( POI_WAREHOUSE2_LARGE, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Warehouse_Exterior_2Floors_256_03.tile" ),
		addPoiTile( POI_WAREHOUSE2_LARGE, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Warehouse_Exterior_2Floors_256_04.tile" )
	}
	g_poiTiles[POI_WAREHOUSE3_LARGE] = {
		addPoiTile( POI_WAREHOUSE3_LARGE, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Warehouse_Exterior_3Floors_256_01.tile" ),
	}
	g_poiTiles[POI_WAREHOUSE4_LARGE] = {
		addPoiTile( POI_WAREHOUSE4_LARGE, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Warehouse_Exterior_4Floors_256_01.tile" ),
	}
	g_poiTiles[POI_BURNTFOREST_FARMBOTSCRAPYARD_LARGE] = {
		addPoiTile( POI_BURNTFOREST_FARMBOTSCRAPYARD_LARGE, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/FarmbotGraveyard_256_01.tile" ),
		addPoiTile( POI_BURNTFOREST_FARMBOTSCRAPYARD_LARGE, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/FarmbotGraveyard_256_02.tile" ),
	}

	-- Small Random
	-- Road
	g_poiTiles[POI_ROAD] = {
		-- Added twice for increased chance
		addPoiTile( POI_ROAD, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Kiosk_64_01.tile" ),
		addPoiTile( POI_ROAD, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Kiosk_64_01.tile" ),
		addPoiTile( POI_ROAD, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Kiosk_64_02.tile" ),
		addPoiTile( POI_ROAD, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Kiosk_64_02.tile" ),
		addPoiTile( POI_ROAD, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Kiosk_64_03.tile" ),
		addPoiTile( POI_ROAD, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Kiosk_64_03.tile" ),

		addPoiTile( POI_ROAD, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Road_64_01.tile" ),
		addPoiTile( POI_ROAD, 5, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Road_64_02.tile" ),
		addPoiTile( POI_ROAD, 6, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Road_64_03.tile" ),
		addPoiTile( POI_ROAD, 7, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Road_64_04.tile" ),
	}

	-- Meadow
	g_poiTiles[POI_CAMP] = {
		addPoiTile( POI_CAMP, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Meadow_64_01.tile" ),
	}
	g_poiTiles[POI_RUIN] = {
		addPoiTile( POI_RUIN, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_01.tile" ),
		addPoiTile( POI_RUIN, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_02.tile" ),
		addPoiTile( POI_RUIN, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_03.tile" ),
		addPoiTile( POI_RUIN, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_04.tile" ),
	}
	g_poiTiles[POI_RANDOM] = {
		addPoiTile( POI_RANDOM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_01.tile" ),
		addPoiTile( POI_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_02.tile" ),
		addPoiTile( POI_RANDOM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_03.tile" ),
		addPoiTile( POI_RANDOM, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_64_04.tile" ),
		addPoiTile( POI_RANDOM, 5, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Meadow_64_01.tile" ),
		addPoiTile( POI_RANDOM, 6, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Meadow_64_02.tile" ),
		addPoiTile( POI_RANDOM, 7, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Meadow_64_03.tile" ),
		addPoiTile( POI_RANDOM, 8, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Meadow_64_04.tile" ),
		addPoiTile( POI_RANDOM, 9, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Meadow_64_05.tile" ),
	}
	g_poiTiles[POI_FARMINGPATCH] = { -- Replaces field with meadow
		addPoiTile( POI_FARMINGPATCH, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/FarmingPatch_64_01.tile" ),
		addPoiTile( POI_FARMINGPATCH, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/FarmingPatch_64_02.tile" ),
		addPoiTile( POI_FARMINGPATCH, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/FarmingPatch_64_03.tile" ),
	}

	-- Forest
	g_poiTiles[POI_FOREST_CAMP] = {
		addPoiTile( POI_FOREST_CAMP, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_01.tile" ),
		addPoiTile( POI_FOREST_CAMP, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_02.tile" ),
		addPoiTile( POI_FOREST_CAMP, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_03.tile" ),
		addPoiTile( POI_FOREST_CAMP, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_04.tile" ),
		addPoiTile( POI_FOREST_CAMP, 5, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_05.tile" ),
		addPoiTile( POI_FOREST_CAMP, 6, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_06.tile" ),
		addPoiTile( POI_FOREST_CAMP, 7, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_Forest_64_07.tile" ),
	}
	g_poiTiles[POI_FOREST_RUIN] = {
		addPoiTile( POI_FOREST_RUIN, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_64_01.tile" ),
		addPoiTile( POI_FOREST_RUIN, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_64_02.tile" ),
		addPoiTile( POI_FOREST_RUIN, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_64_03.tile" ),
	}
	g_poiTiles[POI_FOREST_RANDOM] = {
		addPoiTile( POI_FOREST_RANDOM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_64_01.tile" ),
		addPoiTile( POI_FOREST_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_64_02.tile" ),
		addPoiTile( POI_FOREST_RANDOM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_64_03.tile" ),
		addPoiTile( POI_FOREST_RANDOM, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Forest_64_01.tile" ),
		addPoiTile( POI_FOREST_RANDOM, 5, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Forest_64_02.tile" ),
		addPoiTile( POI_FOREST_RANDOM, 6, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Forest_64_03.tile" ),
		addPoiTile( POI_FOREST_RANDOM, 7, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Forest_64_04.tile" ),
	}

	-- Desert
	g_poiTiles[POI_DESERT_RANDOM] = {
		addPoiTile( POI_DESERT_RANDOM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Desert_64_01.tile" ),
		addPoiTile( POI_DESERT_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Desert_64_02.tile" ),
	}

	-- Field
	g_poiTiles[POI_FIELD_RUIN] = {
		addPoiTile( POI_FIELD_RUIN, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Field_64_01.tile" ),
	}
	g_poiTiles[POI_FIELD_RANDOM] = {
		addPoiTile( POI_FIELD_RANDOM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Field_64_01.tile" ),
		addPoiTile( POI_FIELD_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Field_64_02.tile" ),
		addPoiTile( POI_FIELD_RANDOM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Field_64_03.tile" ),
	}

	-- Burnt forest
	g_poiTiles[POI_BURNTFOREST_CAMP] = {
		addPoiTile( POI_BURNTFOREST_CAMP, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_BurntForest_64_01.tile" ),
	}
	g_poiTiles[POI_BURNTFOREST_RUIN] = {
		addPoiTile( POI_BURNTFOREST_RUIN, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_BurntForest_64_01.tile" ),
	}
	g_poiTiles[POI_BURNTFOREST_RANDOM] = {
		addPoiTile( POI_BURNTFOREST_CAMP, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_BurntForest_64_01.tile" ),
		addPoiTile( POI_BURNTFOREST_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_BurntForest_64_01.tile" ),
	}

	-- Autumn forest
	g_poiTiles[POI_AUTUMNFOREST_CAMP] = {
		addPoiTile( POI_AUTUMNFOREST_CAMP, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_AutumnForest_64_01.tile" ),
		addPoiTile( POI_AUTUMNFOREST_CAMP, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_AutumnForest_64_02.tile" ),
		addPoiTile( POI_AUTUMNFOREST_CAMP, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_AutumnForest_64_03.tile" ),
	}
	g_poiTiles[POI_AUTUMNFOREST_RUIN] = {
		addPoiTile( POI_AUTUMNFOREST_RUIN, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_AutumnForest_64_01.tile" ),
	}
	g_poiTiles[POI_AUTUMNFOREST_RANDOM] = {
		addPoiTile( POI_AUTUMNFOREST_RANDOM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_AutumnForest_64_01.tile" ),
		addPoiTile( POI_AUTUMNFOREST_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_AutumnForest_64_01.tile" ),
		addPoiTile( POI_AUTUMNFOREST_RANDOM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_AutumnForest_64_02.tile" ),
		addPoiTile( POI_AUTUMNFOREST_RANDOM, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/CampingSpot_AutumnForest_64_03.tile" ),
	}
	
	-- Lake
	g_poiTiles[POI_LAKE_RANDOM] = {
		addPoiTile( POI_LAKE_RANDOM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_02.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_03.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 5, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 6, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 7, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 8, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
		addPoiTile( POI_LAKE_RANDOM, 9, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_64_01.tile" ),
	}

	-- Medium Random
	g_poiTiles[POI_CHEMLAKE_MEDIUM] = {
		addPoiTile( POI_CHEMLAKE_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/ChemicalLake_128_01.tile" ),
		addPoiTile( POI_CHEMLAKE_MEDIUM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/ChemicalLake_128_02.tile" ),
		addPoiTile( POI_CHEMLAKE_MEDIUM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/ChemicalLake_128_03.tile" ),
	}
	g_poiTiles[POI_RUIN_MEDIUM] = {
		addPoiTile( POI_RUIN_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_128_01.tile" ),
		addPoiTile( POI_RUIN_MEDIUM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_128_02.tile" ),
		addPoiTile( POI_RUIN_MEDIUM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_128_03.tile" ),
		addPoiTile( POI_RUIN_MEDIUM, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Meadow_128_04.tile" ),
	}
	g_poiTiles[POI_BUILDAREA_MEDIUM] = {
		addPoiTile( POI_BUILDAREA_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Meadow_128_01.tile" ),
	}
	g_poiTiles[POI_FOREST_RUIN_MEDIUM] = {
		addPoiTile( POI_FOREST_RUIN_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Ruin_Forest_128_01.tile" ),
		addPoiTile( POI_FOREST_RUIN_MEDIUM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Forest_128_01.tile" ),
	}
	g_poiTiles[POI_LAKE_UNDERWATER_MEDIUM] = {
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 1, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 2, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_02.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 3, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Island_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 4, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_02.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 5, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 6, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 7, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 8, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 9, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 10, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 11, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),
		addPoiTile( POI_LAKE_UNDERWATER_MEDIUM, 12, "$SURVIVAL_DATA/Terrain/Tiles/poi/Random_Lake_128_01.tile" ),

	}

	-- TEST
	g_poiTiles[POI_TEST] = {
		addPoiTile( POI_TEST, 1, "$SURVIVAL_DATA/Terrain/Tiles/test/TestHideout.tile" ),
		addPoiTile( POI_TEST, 2, "$SURVIVAL_DATA/Terrain/Tiles/test/elevator_test_warehouse.tile" ),
		addPoiTile( POI_TEST, 3, "$SURVIVAL_DATA/Terrain/Tiles/test/AllTrees.tile" ),
		addPoiTile( POI_TEST, 4, "$SURVIVAL_DATA/Terrain/Tiles/test/Fences.tile" ),
		addPoiTile( POI_TEST, 5, "$SURVIVAL_DATA/Terrain/Tiles/test/Loot.tile" ),
	}

	--RAFT
	g_poiTiles[POI_RAFT] = {
		addPoiTile( POI_RAFT, 1, "$SURVIVAL_DATA/RaftMod/Tiles/AbandonedBoat(RaftMod).tile" )
	}
end

----------------------------------------------------------------------------------------------------
-- Getters
----------------------------------------------------------------------------------------------------

function getPoiTileIdAndRotation( poiType, variationNoise, rotationNoise )
	assert( poiType ~= POI_CRASHSITE_AREA, "Don't call this for crash site tiles" )
	
	local tileCount = 0
	if g_poiTiles[poiType] then
		tileCount = table.getn( g_poiTiles[poiType] )
	end

	if tileCount == 0 then
		return -1, 0 --error tile
	end

	return g_poiTiles[poiType][variationNoise % tileCount + 1], rotationNoise % 4
end
