extends Control

signal tasks_assigned

var team_system
var task_system
var selected_character = null
var characters = {}

func _ready():
	# Inicializamos personajes
	characters["Ana"] = {"task": null}
	characters["Mateo"] = {"task": null}
	characters["Sofia"] = {"task": null}

func setup(team, task_sys):
	team_system = team
	task_system = task_sys

func assign_task(task_name):
	if selected_character == null:
		print("Selecciona un personaje primero")
		return
	characters[selected_character]["task"] = task_name
	print(selected_character, " asignado a ", task_name)

func _on_character_pressed():
	var button = get_viewport().gui_get_focus_owner()
	selected_character = button.text
	print("Seleccionado: ", selected_character)


func _on_programming_pressed():
	assign_task("programming")

func _on_design_pressed():
	assign_task("design")

func _on_testing_pressed():
	assign_task("testing")

func _on_rest_pressed():
	assign_task("rest")
	
func _on_confirm_button_pressed():
	print("Asignaciones finales:")
	print(characters)
	emit_signal("tasks_assigned")
