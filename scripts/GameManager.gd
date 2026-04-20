extends Node

const EventSystem = preload("res://scripts/EventSystem.gd")

#Este es el orquestrador de todo el juego

@onready var ui = $"../UIController"
@onready var team = $TeamSystem
@onready var tasks = $TaskSystem
@onready var project = $ProjectSystem
var event_system


var day = 1
var max_days = 3

func _ready():
	event_system = EventSystem.new()
	add_child(event_system)
	event_system.connect("event_requested", Callable(self, "_on_event_requested"))
	event_system.connect("event_resolved", Callable(self, "_on_event_resolved"))
	run_game()

func run_game():
	while day <= max_days:
		print("Día ", day)
		
		assign_tasks()
		for c in team.characters:
			c.event_modifier = 0
			var event = event_system.maybe_trigger_random_event(c, c.assigned_task)
			if event:
				var decision = ask_player_decision(c, event)
				event_system.resolve_event(c, event, decision)
		
		var results = tasks.resolve_all(team.characters)
		project.apply_results(results)
		
		print(results)
		
		day += 1

func assign_tasks():
	for c in team.characters:
		# Temporal: asignación automática
		c.assigned_task = ["programming", "design", "testing"].pick_random()
		print(c.name, " Assigned to ", c.assigned_task)

func ask_player_decision(character, event):
	print("Evento aleatorio para ", character.name, ": ", event.description)
	print("  Sí -> ", event.yes_text, " (", event.yes_delta, ")")
	print("  No -> ", event.no_text, " (", event.no_delta, ")")

	# Por ahora se simula siempre una respuesta sí.
	# Más adelante reemplazar con UI o entrada interactiva.
	return true

func _on_event_requested(character, _event):
	print("[Evento solicitado] ", character.name)

func _on_event_resolved(_character, _event, accepted, score_delta):
	var decision_text = "no"
	if accepted:
		decision_text = "sí"
	print(_character.name, " eligió ", decision_text, " y el puntaje cambia en ", score_delta)
