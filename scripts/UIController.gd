extends Control

# Señales del flujo principal
signal tasks_assigned
signal task_calculation_started
signal event_processing_started
signal day_finished
signal game_finished

signal start_project_requested
signal continue_to_tasks_requested
signal continue_to_calculation_requested
signal continue_to_events_requested
signal continue_to_finish_day_requested
signal event_decision_made(character_index, decision)

var team_system
var task_system
var event_system
var project_system
var game_manager

var selected_character = null
var characters = {}
var character_names = ["Ana", "Mateo", "Sofia"]
@export var container: Node
var character_card_scene = preload("res://escenas/character_card.tscn")

# Referencia a los paneles
var assignment_panel
var event_panel
var results_panel
var game_over_panel

# Estado del evento actual
var current_event_data = null
var current_event_index = 0

func _ready():
	# Inicializamos personajes
	for name in character_names:
		characters[name] = {"task": null}
	
	# Obtener referencias a los paneles
	assignment_panel = $AssignmentPanel
	event_panel = $EventPanel
	results_panel = $ResultsPanel
	game_over_panel = $GameOverPanel

func setup(team, task_sys, event_sys, project_sys, gm):
	team_system = team
	task_system = task_sys
	event_system = event_sys
	project_system = project_sys
	game_manager = gm

func assign_task(task_name):
	if selected_character == null:
		print("Selecciona un personaje primero")
		return
	characters[selected_character]["task"] = task_name
	print(selected_character, " asignado a ", task_name)

func load_characters(characters):
	print("Llamando load_characters")
	for c in characters:
		print("Creando card para: ", c.name)
		var card = character_card_scene.instantiate()
		card.set_character(c)
		container.add_child(card)

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
	
	# Aplicar asignaciones a los personajes del team_system
	if team_system:
		for i in range(team_system.characters.size()):
			var character = team_system.characters[i]
			if character.name in characters:
				character.assigned_task = characters[character.name]["task"]
				print("Aplicado: ", character.name, " -> ", character.assigned_task)
	
	# Ocultar panel de asignación y mostrar evento (si hay)
	_show_assignment_panel(false)
	
	emit_signal("tasks_assigned")

func show_event_decision(character, event, event_index):
	"""Muestra una UI con la decisión del evento"""
	current_event_data = {
		"character": character,
		"event": event,
		"index": event_index
	}
	current_event_index = event_index
	
	print("Mostrando evento para ", character.name, ": ", event.description)
	
	# Actualizar UI del evento
	var event_title = event_panel.get_node("EventTitle")
	var event_description = event_panel.get_node("EventDescription")
	var yes_button = event_panel.get_node("YesButton")
	var no_button = event_panel.get_node("NoButton")
	
	event_title.text = character.name + " - " + event.id
	event_description.text = event.description
	yes_button.text = event.yes_text + " (+%d)" % event.yes_delta
	no_button.text = event.no_text + " (%d)" % event.no_delta
	
	# Mostrar panel de evento
	_show_event_panel(true)

func _on_event_yes_pressed():
	if current_event_data:
		emit_signal("event_decision_made", current_event_index, true)
		# No ocultar el panel inmediatamente, dejar que GameManager lo maneje

func _on_event_no_pressed():
	if current_event_data:
		emit_signal("event_decision_made", current_event_index, false)
		# No ocultar el panel inmediatamente, dejar que GameManager lo maneje

func show_results(results):
	"""Muestra los resultados del día"""
	print("Mostrando resultados del día")
	
	# Actualizar etiquetas de resultados
	var prog_label = results_panel.get_node("ProgrammingResult")
	var design_label = results_panel.get_node("DesignResult")
	var testing_label = results_panel.get_node("TestingResult")
	
	prog_label.text = "Programming: %d" % results["programming"]
	design_label.text = "Design: %d" % results["design"]
	testing_label.text = "Testing: %d" % results["testing"]
	
	# Mostrar panel de resultados
	_show_results_panel(true)

func _on_continue_button_pressed():
	print("Continuando a próximo día")
	_show_results_panel(false)
	_show_assignment_panel(true)
	
	# Limpiar asignaciones para el nuevo día
	for name in character_names:
		characters[name]["task"] = null
	
	# Reiniciar el siguiente día
	if game_manager:
		game_manager.start_day()

func show_game_over(final_stats):
	"""Muestra la pantalla de fin de juego"""
	print("Mostrando pantalla de fin de juego")
	
	_show_results_panel(false)
	_show_event_panel(false)
	_show_assignment_panel(false)
	
	# Actualizar etiquetas de fin de juego
	var title = game_over_panel.get_node("GameOverTitle")
	var prog_label = game_over_panel.get_node("ProgrammingFinal")
	var design_label = game_over_panel.get_node("DesignFinal")
	var testing_label = game_over_panel.get_node("TestingFinal")
	
	title.text = "¡FIN DEL JUEGO!"
	prog_label.text = "Programming: %d" % final_stats["programming"]
	design_label.text = "Design: %d" % final_stats["design"]
	testing_label.text = "Testing: %d" % final_stats["testing"]
	
	_show_game_over_panel(true)

func _on_restart_button_pressed():
	print("Reiniciando juego")
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	print("Saliendo del juego")
	get_tree().quit()

# Funciones auxiliares para mostrar/ocultar paneles
func _show_assignment_panel(visible: bool):
	if assignment_panel:
		assignment_panel.visible = visible

func _show_event_panel(visible: bool):
	if event_panel:
		event_panel.visible = visible

func _show_results_panel(visible: bool):
	if results_panel:
		results_panel.visible = visible

func _show_game_over_panel(visible: bool):
	if game_over_panel:
		game_over_panel.visible = visible
