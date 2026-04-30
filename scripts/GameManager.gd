extends Node

const EventSystem = preload("res://scripts/EventSystem.gd")
const EVENT_ALERT_DURATION := 0.8

# Este es el orquestrador de todo el juego

var ui: Control
var team: Node
var tasks: Node
var project: Node
var project_progress_ui: Node
var deadline_ui: Node

var event_system
var event_background: CanvasItem
var event_alert_overlay: Control
var event_exclamation: CanvasItem
var event_alert_audio: AudioStreamPlayer
var current_day = 1
var max_days = 3
var current_event_index = 0
var pending_events = []
var active_event_data: Dictionary = {}

func _ready():
	# Obtener referencias a los sistemas
	team = $TeamSystem
	tasks = $TaskSystem
	project = $ProjectSystem
	
	# Obtener referencia a UI (puede estar en CanvasLayer o no)
	ui = get_tree().root.find_child("UIController", true, false)
	if not ui:
		ui = get_node_or_null("../CanvasLayer/UIController")
	event_background = get_node_or_null("../Background")
	if event_background == null:
		event_background = find_child("Background", true, false)
	event_alert_overlay = get_node_or_null("../CanvasLayer/EventAlert")
	if event_alert_overlay == null:
		event_alert_overlay = find_child("EventAlert", true, false)
	event_exclamation = get_node_or_null("../CanvasLayer/EventAlert/ExclamationMark")
	if event_exclamation == null:
		event_exclamation = find_child("ExclamationMark", true, false)
	event_alert_audio = get_node_or_null("EventAlertSound")
	if event_alert_audio == null:
		event_alert_audio = find_child("EventAlertSound", true, false)
	
	project_progress_ui = get_tree().root.find_child("ProjectProgressUI", true, false)
	deadline_ui = get_tree().root.find_child("DeadlineUi", true, false)
	if deadline_ui == null:
		deadline_ui = get_tree().root.find_child("DeadlineUI", true, false)

	event_system = EventSystem.new()
	add_child(event_system)
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	_clear_event_visuals()
	
	# Conectar señales de UI
	if ui:
		ui.setup(team, tasks, event_system, project, self)
		ui.connect("tasks_assigned", Callable(self, "_on_tasks_assigned"))
		ui.load_characters(team.characters)

	if project_progress_ui:
		project_progress_ui.call_deferred("setup", project.get_completion_summary())

	if deadline_ui:
		deadline_ui.call_deferred("setup", max_days - current_day + 1)
		if deadline_ui.has_signal("deadline_reached") and not deadline_ui.deadline_reached.is_connected(_on_deadline_reached):
			deadline_ui.deadline_reached.connect(_on_deadline_reached)
	
	start_day()

func start_day():
	print("\n=== DÍA ", current_day, " ===")
	if ui:
		print("Esperando asignación de tareas...")

func _on_tasks_assigned():
	"""Se llamó cuando el jugador confirmó las tareas"""
	print("\nTareas asignadas. Comenzando cálculo...")
	process_events()

func process_events():
	"""Genera y procesa los eventos del día"""
	pending_events = []

	var eligible_characters: Array = []
	for c in team.characters:
		c.event_modifier = 0
		if c.assigned_task == null:
			print("[Eventos] ", c.name, " no tiene tarea asignada; se omite la selección de evento.")
			continue
		eligible_characters.append(c)

	if eligible_characters.is_empty():
		print("[Eventos] No hay personajes con tarea asignada para generar eventos.")
		calculate_tasks()
		return

	eligible_characters.shuffle()
	var target_events := 1 + (randi() % 2) # Entre 1 y 2 eventos por día.

	for c in eligible_characters:
		if pending_events.size() >= target_events:
			break
		var event = event_system.pick_event(c, c.assigned_task, team.characters)
		if event.is_empty():
			continue
		pending_events.append({
			"character": c,
			"event": event
		})

	# Fallback: si no salió nada por agotamiento de pool, reinicia y fuerza 1 evento.
	if pending_events.is_empty():
		print("[Eventos] Sin candidatos disponibles. Reiniciando pool de eventos jugados.")
		event_system.reset_played_events()
		eligible_characters.shuffle()
		for c in eligible_characters:
			var fallback_event = event_system.pick_event(c, c.assigned_task, team.characters)
			if fallback_event.is_empty():
				continue
			pending_events.append({
				"character": c,
				"event": fallback_event
			})
			break

	print("Eventos generados: ", pending_events.size(), " (objetivo: ", target_events, ")")
	
	if pending_events.is_empty():
		# No hay eventos, ir directamente a calcular
		calculate_tasks()
	else:
		# Mostrar el primer evento
		current_event_index = 0
		launch_next_event()

func launch_next_event() -> void:
	"""Lanza el siguiente timeline de Dialogic, o termina si no quedan eventos."""
	if current_event_index >= pending_events.size():
		_clear_event_visuals()
		calculate_tasks()
		return
	
	active_event_data = pending_events[current_event_index]
	var character = active_event_data["character"]
	var event = active_event_data["event"]
	await _play_event_alert_sequence()
	print("[Evento iniciado] ", character.name, " - ", event.id)
	Dialogic.start(event.id)

func calculate_tasks():
	"""Calcula los resultados de las tareas del día"""
	_clear_event_visuals()
	print("\nCalculando resultados...")
	var results = tasks.resolve_all(team.characters)
	
	if ui:
		ui.show_results(results)
	
	# Aplicar resultados al proyecto
	project.apply_results(results)
	
	if project_progress_ui:
		project_progress_ui.setup(project.get_completion_summary())

	"""Finaliza el día"""
	print("\nFin del día ", current_day)
	print("Estado del proyecto:")
	print("  Programming: ", project.programming)
	print("  Design: ", project.design)
	print("  Testing: ", project.testing)
	
	current_day += 1

	if deadline_ui:
		deadline_ui.advance_day(1)
	
	if current_day <= max_days:
		# Iniciar el siguiente día
		print("\nPresiona cualquier botón para el siguiente día...")
		start_day()
	else:
		print("\n=== FIN DEL JUEGO ===")
		print("Proyecto final:")
		print("  Programming: ", project.programming)
		print("  Design: ", project.design)
		print("  Testing: ", project.testing)
		
		# Mostrar pantalla de fin de juego
		if ui:
			var final_stats = {
				"programming": project.programming,
				"design": project.design,
				"testing": project.testing
			}
			ui.show_game_over(final_stats)

func _on_deadline_reached() -> void:
	_clear_event_visuals()
	print("[Deadline] Se alcanzó la fecha límite")
	if ui:
		var final_stats = {
			"programming": project.programming,
			"design": project.design,
			"testing": project.testing
		}
		ui.show_game_over(final_stats)

func _on_dialogic_timeline_ended() -> void:
	if active_event_data.is_empty():
		return
	var character = active_event_data["character"]
	var event = active_event_data["event"]
	_clear_event_visuals()
	print("[Evento terminado] ", character.name, " - ", event.id)
	active_event_data = {}
	current_event_index += 1
	await get_tree().process_frame
	launch_next_event()


func _play_event_alert_sequence() -> void:
	if event_background:
		event_background.visible = true
	if event_alert_overlay:
		event_alert_overlay.visible = true
	if event_exclamation:
		event_exclamation.visible = true
	if event_alert_audio:
		event_alert_audio.stop()
		event_alert_audio.play()
	await get_tree().create_timer(EVENT_ALERT_DURATION).timeout
	if event_alert_overlay:
		event_alert_overlay.visible = false
	if event_exclamation:
		event_exclamation.visible = false


func _clear_event_visuals() -> void:
	if event_alert_audio:
		event_alert_audio.stop()
	if event_alert_overlay:
		event_alert_overlay.visible = false
	if event_exclamation:
		event_exclamation.visible = false
	if event_background:
		event_background.visible = false


func _on_character_pressed() -> void:
	pass # Replace with function body.
