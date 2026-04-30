extends Node

signal event_requested(character, event)
signal event_resolved(character, event, accepted, score_delta)

var events = [
	{
		"id": "client_change",
		"description": "Un cliente pide un cambio urgente en la tarea actual.",
		"task": "programming",
		"yes_delta": 4,
		"no_delta": -2,
		"yes_text": "Aceptas el cambio y el resultado mejora.",
		"no_text": "Rechazas y hay una penalización."
	},
	{
		"id": "creative_block",
		"description": "Tu equipo tiene una dificultad creativa con esta tarea.",
		"task": "design",
		"yes_delta": 3,
		"no_delta": -1,
		"yes_text": "Buscas nuevas ideas y aumentas el puntaje.",
		"no_text": "No tomas riesgos y el puntaje baja."
	},
	{
		"id": "bug_discovery",
		"description": "Encuentran un bug importante durante la tarea.",
		"task": "testing",
		"yes_delta": 2,
		"no_delta": -3,
		"yes_text": "Investigas el bug y mejoras el resultado.",
		"no_text": "Ignoras el bug y pierdes puntos."
	},
	{
		"id": "any_help",
		"description": "Hay una oportunidad extra que puede ayudar a cualquier tarea.",
		"task": "any",
		"yes_delta": 2,
		"no_delta": -1,
		"yes_text": "Aprovechas la oportunidad y sumas puntaje.",
		"no_text": "No la tomas y pierdes impulso."
	}
]

func _ready():
	randomize()

func pick_event(task_type):
	var candidates = []
	for e in events:
		if e.task == task_type or e.task == "any":
			candidates.append(e)
	if candidates.is_empty():
		return null
	return candidates[randi() % candidates.size()]

func maybe_trigger_random_event(character, task_type):
	if randi() % 100 >= 50:
		return null
	var event = pick_event(task_type)
	if event == null:
		return null
	emit_signal("event_requested", character, event)
	return event

func resolve_event(character, event, accepted):
	if event == null:
		return 0
	var delta = 0
	if accepted:
		delta = event.yes_delta
	else:
		delta = event.no_delta
	character.event_modifier = delta
	emit_signal("event_resolved", character, event, accepted, delta)
	return delta

func get_decision_text(event, accepted):
	if accepted:
		return event.yes_text
	return event.no_text
