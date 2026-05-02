extends Node

## Each entry maps a Dialogic timeline ID to its activation conditions.
## The timeline ID must match the identifier used in Dialogic.start().

var events: Array = [
	{
		"id": "res://dialogic/timelines/events/Event_Programador Confiado.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Probar es aburrido Erick.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Erick"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_No me gusta programar.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_No hay coordinacion.dtl",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": ["Karol"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_David deuda tecnica oculta.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Erick cambios de ultimo minuto.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Erick"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Jhonatan falso positivo critico.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Karol prioridades en conflicto.dtl",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": ["Karol"],
			"required_team_characters": []
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_David y Jhonatan choque de criterios.dtl",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": ["David", "Jhonatan"],
			"required_team_characters": ["David", "Jhonatan"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Erick y Karol alcance visual.dtl",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": ["Erick", "Karol"],
			"required_team_characters": ["Erick", "Karol"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Jhonatan y Erick reporte ambiguo.dtl",
		"task": "any",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "Erick"],
			"required_team_characters": ["Jhonatan", "Erick"]
		}
	}
]

var played_event_ids: Dictionary = {}

func _ready() -> void:
	randomize()

## Returns a random eligible event dict for the character, or {} if none found.
func pick_event(character: Object, task_type = null, team_characters: Array = []) -> Dictionary:
	if task_type == null:
		return {}
	var normalized_task_type := str(task_type)
	var candidates: Array = []
	for e in events:
		var event_id: String = str(e.get("id", ""))
		if event_id.is_empty() or has_event_been_played(event_id):
			continue
		if (e.task == normalized_task_type or e.task == "any") and can_activate_event(e, character, team_characters):
			candidates.append(e)
	if candidates.is_empty():
		return {}
	var chosen_event: Dictionary = candidates[randi() % candidates.size()]
	mark_event_as_played(str(chosen_event.get("id", "")))
	return chosen_event

## 50% chance to pick an eligible event. Returns {} when no event fires.
func maybe_pick_event(character: Object, task_type = null, team_characters: Array = []) -> Dictionary:
	if task_type == null:
		return {}
	if randi() % 100 >= 50:
		return {}
	return pick_event(character, task_type, team_characters)

func has_event_been_played(event_id: String) -> bool:
	return played_event_ids.has(event_id)

func mark_event_as_played(event_id: String) -> void:
	if event_id.is_empty():
		return
	played_event_ids[event_id] = true

func reset_played_events() -> void:
	played_event_ids.clear()

func can_activate_event(event: Dictionary, character: Object, team_characters: Array) -> bool:
	var conditions: Dictionary = event.get("activation_conditions", {})
	var allowed_characters: Array = conditions.get("allowed_characters", [])
	if not allowed_characters.is_empty() and not allowed_characters.has(character.name):
		return false

	var team_names: Array = []
	for member in team_characters:
		team_names.append(member.name)

	var required_team_characters: Array = conditions.get("required_team_characters", [])
	for required_name in required_team_characters:
		if not team_names.has(required_name):
			return false

	return true
