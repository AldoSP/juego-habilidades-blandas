extends Node

var game_manager = null

func modify_project_progress(stat:String, amount:int):
	if game_manager:
		game_manager.modify_project_progress(stat, amount)

func modify_active_character_energy(amount:int):
	if game_manager:
		game_manager.modify_active_character_energy(amount)

func modify_active_character_task_modifier(amount:int):
	if game_manager:
		game_manager.modify_active_character_task_modifier(amount)
