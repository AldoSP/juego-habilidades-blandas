extends Node

signal event_requested(character, event)
signal event_resolved(character, event, accepted, score_delta)

var events = [
	{
		"id": "client_change",
		"description": "Un cliente le pide a {character_name} un cambio urgente en la tarea actual.",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": [],
			"required_team_characters": []
		},
		"yes_delta": 4,
		"no_delta": -2,
		"yes_text": "{character_name} acepta el cambio y el resultado mejora.",
		"no_text": "{character_name} lo rechaza y hay una penalización."
	},
	{
		"id": "creative_block",
		"description": "{character_name} detecta una dificultad creativa en esta tarea.",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": [],
			"required_team_characters": []
		},
		"yes_delta": 3,
		"no_delta": -1,
		"yes_text": "{character_name} busca nuevas ideas y aumenta el puntaje.",
		"no_text": "{character_name} no toma riesgos y el puntaje baja."
	},
	{
		"id": "bug_discovery",
		"description": "{character_name} encuentra un bug importante durante la tarea.",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": [],
			"required_team_characters": []
		},
		"yes_delta": 2,
		"no_delta": -3,
		"yes_text": "{character_name} investiga el bug y mejora el resultado.",
		"no_text": "{character_name} ignora el bug y pierde puntos."
	},
	{
		"id": "any_help",
		"description": "A {character_name} se le presenta una oportunidad extra que puede ayudar a cualquier tarea.",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": [],
			"required_team_characters": []
		},
		"yes_delta": 2,
		"no_delta": -1,
		"yes_text": "{character_name} aprovecha la oportunidad y suma puntaje.",
		"no_text": "{character_name} no la toma y pierde impulso."
	},
	{
		"id": "dupla_imparable",
		"description": "{character_name} detecta una buena sinergia con el equipo y aparece una oportunidad especial.",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": ["David", "Erick"],
			"required_team_characters": ["David", "Erick"]
		},
		"yes_delta": 3,
		"no_delta": -2,
		"yes_text": "{character_name} coordina al equipo y la sinergia mejora el avance.",
		"no_text": "{character_name} deja pasar la oportunidad y el equipo pierde impulso."
	}
]

func _ready():
	randomize()

func pick_event(character, task_type, team_characters = []):
	var candidates = []
	for e in events:
		if (e.task == task_type or e.task == "any") and can_activate_event(e, character, team_characters):
			candidates.append(build_event_instance(e, character))
	if candidates.is_empty():
		return null
	return candidates[randi() % candidates.size()]

func maybe_trigger_random_event(character, task_type, team_characters = []):
	if randi() % 100 >= 50:
		return null
	var event = pick_event(character, task_type, team_characters)
	if event == null:
		return null
	emit_signal("event_requested", character, event)
	return event

func can_activate_event(event, character, team_characters) -> bool:
	var conditions = event.get("activation_conditions", {})
	var allowed_characters = conditions.get("allowed_characters", [])
	if not allowed_characters.is_empty() and not allowed_characters.has(character.name):
		return false

	var team_names = []
	for member in team_characters:
		team_names.append(member.name)

	var required_team_characters = conditions.get("required_team_characters", [])
	for required_name in required_team_characters:
		if not team_names.has(required_name):
			return false

	return true

func build_event_instance(event, character):
	var event_instance = event.duplicate(true)
	event_instance.description = format_event_text(event_instance.description, character)
	event_instance.yes_text = format_event_text(event_instance.yes_text, character)
	event_instance.no_text = format_event_text(event_instance.no_text, character)
	return event_instance

func format_event_text(text: String, character) -> String:
	return text.replace("{character_name}", character.name)

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
