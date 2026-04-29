extends Node

const EventSystem = preload("res://scripts/EventSystem.gd")

# Este es el orquestrador de todo el juego

var ui: Control
var team: Node
var tasks: Node
var project: Node

var event_system
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
	
	event_system = EventSystem.new()
	add_child(event_system)
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	
	# Conectar señales de UI
	if ui:
		ui.setup(team, tasks, event_system, project, self)
		ui.connect("tasks_assigned", Callable(self, "_on_tasks_assigned"))
		ui.load_characters(team.characters)
	
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
	
	# Generar eventos para cada personaje
	for c in team.characters:
		c.event_modifier = 0
		if c.assigned_task == null:
			print("[Eventos] ", c.name, " no tiene tarea asignada; se omite la selección de evento.")
			continue
		var event = event_system.maybe_pick_event(c, c.assigned_task, team.characters)
		if not event.is_empty():
			pending_events.append({
				"character": c,
				"event": event
			})
	
	print("Eventos generados: ", pending_events.size())
	
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
		calculate_tasks()
		return
	
	active_event_data = pending_events[current_event_index]
	var character = active_event_data["character"]
	var event = active_event_data["event"]
	print("[Evento iniciado] ", character.name, " - ", event.id)
	Dialogic.start(event.id)

func calculate_tasks():
	"""Calcula los resultados de las tareas del día"""
	print("\nCalculando resultados...")
	var results = tasks.resolve_all(team.characters)
	
	if ui:
		ui.show_results(results)
	
	# Aplicar resultados al proyecto
	project.apply_results(results)
	
	end_day()

func end_day():
	"""Finaliza el día"""
	print("\nFin del día ", current_day)
	print("Estado del proyecto:")
	print("  Programming: ", project.programming)
	print("  Design: ", project.design)
	print("  Testing: ", project.testing)
	
	current_day += 1
	
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

func _on_dialogic_timeline_ended() -> void:
	if active_event_data.is_empty():
		return
	var character = active_event_data["character"]
	var event = active_event_data["event"]
	print("[Evento terminado] ", character.name, " - ", event.id)
	active_event_data = {}
	current_event_index += 1
	await get_tree().process_frame
	launch_next_event()


func _on_character_pressed() -> void:
	pass # Replace with function body.
