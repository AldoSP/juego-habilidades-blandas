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

var team_system
var task_system
var event_system
var project_system
var game_manager

var selected_character = null
var characters = {}
var character_names = ["David", "Erick", "Jhonatan", "Karol"]
@export var container: Node
var character_card_scene = preload("res://escenas/character_card.tscn")
var assignment_board_scene = preload("res://escenas/assignment_board.tscn")

const ASSIGNMENT_CATEGORIES = [
	{ "id": "programming", "label": "Programming" },
	{ "id": "design", "label": "Design" },
	{ "id": "testing", "label": "Testing" },
	{ "id": "rest", "label": "Rest" }
]

# Referencia a los paneles
var assignment_panel
var event_panel
var results_panel
var game_over_panel
var assignment_board

# Estado del evento actual ya no es necesario; Dialogic maneja las decisiones

func _ready():
	# Inicializamos personajes
	for name in character_names:
		characters[name] = {"task": null}
	
	# Obtener referencias a los paneles
	assignment_panel = $AssignmentBoard
	results_panel = $ResultsPanel
	game_over_panel = $GameOverPanel
	_initialize_assignment_board()
	# Conectar señal del nuevo ResultsPanel
	if results_panel and not results_panel.continue_pressed.is_connected(_on_continue_button_pressed):
		results_panel.continue_pressed.connect(_on_continue_button_pressed)

func setup(team, task_sys, event_sys, project_sys, gm):
	team_system = team
	task_system = task_sys
	event_system = event_sys
	project_system = project_sys
	game_manager = gm
	_ensure_assignment_board_initialized()
	call_deferred("load_assignment_board", team_system.characters)

func _initialize_assignment_board():
	if assignment_board == null:
		assignment_board = get_node_or_null("AssignmentBoard")

	if assignment_board != null:
		if not assignment_board.assignments_confirmed.is_connected(_on_assignment_board_confirmed):
			assignment_board.assignments_confirmed.connect(_on_assignment_board_confirmed)
		return

	if assignment_panel == null:
		return
	if assignment_board != null:
		return

	assignment_board = assignment_board_scene.instantiate()
	assignment_board.name = "AssignmentBoard"
	assignment_board.set_anchors_preset(Control.PRESET_FULL_RECT)
	assignment_board.offset_left = 0
	assignment_board.offset_top = 0
	assignment_board.offset_right = 0
	assignment_board.offset_bottom = 0
	assignment_panel.add_child(assignment_board)

	assignment_board.assignments_confirmed.connect(_on_assignment_board_confirmed)

func _ensure_assignment_board_initialized():
	if assignment_panel == null:
		assignment_panel = get_node_or_null("AssignmentPanel")
	_initialize_assignment_board()

func load_assignment_board(team_characters):
	_ensure_assignment_board_initialized()
	if assignment_board == null:
		print("No se pudo inicializar AssignmentBoard")
		return

	var board_characters = []
	for c in team_characters:
		var char_name = _get_character_name(c)
		if char_name == "":
			continue
		board_characters.append(c)

	print("Cargando AssignmentBoard con ", board_characters.size(), " personajes")
	assignment_board.setup_board(board_characters, ASSIGNMENT_CATEGORIES)

func _get_character_name(character_data) -> String:
	if typeof(character_data) == TYPE_DICTIONARY:
		if character_data.has("name"):
			return str(character_data["name"])
		return ""

	if character_data == null:
		return ""

	if typeof(character_data) != TYPE_OBJECT:
		return str(character_data)

	if character_data.get("name") == null:
		return ""

	return str(character_data.get("name"))

func _on_assignment_board_confirmed(assignments):
	if team_system:
		for character in team_system.characters:
			if assignments.has(character.name):
				character.assigned_task = assignments[character.name]
				print("Aplicado: ", character.name, " -> ", character.assigned_task)

	_show_assignment_panel(false)
	emit_signal("tasks_assigned")

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

func show_results(results: Dictionary, summary_lines: Array[String] = [], event_lines: Array[String] = []):
	"""Muestra los resultados del día"""
	print("Mostrando resultados del día")
	results_panel.set_results(results["programming"], results["design"], results["testing"])
	results_panel.set_event_summary(event_lines)
	results_panel.set_summary(summary_lines)
	results_panel.show()

func _on_continue_button_pressed():
	print("Continuando a próximo día")
	_show_assignment_panel(true)
	# Limpiar asignaciones locales para el nuevo día
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
	prog_label.text = "Programación: %d" % final_stats["programming"]
	design_label.text = "Diseño: %d" % final_stats["design"]
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


func _on_character_d_pressed() -> void:
	pass # Replace with function body.
