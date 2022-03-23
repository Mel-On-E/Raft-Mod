quest_use_terminal = "be627075-4fc5-4c7d-a3b8-aec040b9776f"
quest_pickup_logbook = "bfb6e5b6-3ee3-4310-a1b3-7608eb3ecb8d"

quest_mechanic_station = "bf68d177-878c-4017-b146-39354d44d888"
quest_radio_interactive = "26ca3794-71f2-4648-a97c-997802680c95"

SurvivalQuests = {
	[quest_use_terminal] = {
		followup = quest_pickup_logbook
	},

	[quest_pickup_logbook] = {
		followup = quest_mechanic_station
	},

	[quest_mechanic_station] = {
		followup = quest_radio_interactive
	}
}