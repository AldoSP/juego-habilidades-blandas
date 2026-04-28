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
	event_system.connect("event_requested", Callable(self, "_on_event_requested"))
	event_system.connect("event_resolved", Callable(self, "_on_event_resolved"))
	
	# Conectar señales de UI
	if ui:
		ui.setup(team, tasks, event_system, project, self)
		ui.connect("tasks_assigned", Callable(self, "_on_tasks_assigned"))
		ui.connect("event_decision_made", Callable(self, "_on_event_decision_made"))
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
		var event = event_system.maybe_trigger_random_event(c, c.assigned_task, team.characters)
		if event:
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
		show_next_event()

func show_next_event():
	"""Muestra el siguiente evento o termina el procesamiento"""
	if current_event_index >= pending_events.size():
		# Ya se procesaron todos los eventos
		calculate_tasks()
		return
	
	var event_data = pending_events[current_event_index]
	var character = event_data["character"]
	var event = event_data["event"]
	
	print("\nEvento para ", character.name, ": ", event.description)
	print("  Sí: ", event.yes_text)
	print("  No: ", event.no_text)
	
	# Mostrar en UI si está disponible
	if ui:
		ui.show_event_decision(character, event, current_event_index)
	else:
		# Si no hay UI, simular una decisión
		var decision = randf() > 0.5
		_on_event_decision_made(current_event_index, decision)

func _on_event_decision_made(event_index, decision):
	"""Se llamó cuando el jugador tomó una decisión sobre un evento"""
	if event_index != current_event_index:
		return
	
	var event_data = pending_events[current_event_index]
	var character = event_data["character"]
	var event = event_data["event"]
	
	event_system.resolve_event(character, event, decision)
	print(character.name, " decidió: ", "Sí" if decision else "No")
	
	# Ocultar panel de evento
	if ui:
		ui._show_event_panel(false)
	
	current_event_index += 1
	
	# Pequeño delay para evitar problemas de UI cuando hay eventos consecutivos
	await get_tree().process_frame
	show_next_event()

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

func _on_event_requested(character, _event):
	print("[Evento solicitado] ", character.name)

func _on_event_resolved(_character, _event, accepted, score_delta):
	var decision_text = "no"
	if accepted:
		decision_text = "sí"
	print(_character.name, " eligió ", decision_text, " y el puntaje cambia en ", score_delta)


func _on_character_pressed() -> void:
	pass # Replace with function body.
