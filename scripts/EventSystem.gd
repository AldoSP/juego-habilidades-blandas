extends Node

## Each entry maps a Dialogic timeline ID to its activation conditions.
## The timeline ID must match the identifier used in Dialogic.start().

var events: Array = [
	{
		"id": "client_change",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Karol"],
			"required_team_characters": []
		}
	}
]
func _ready() -> void:
	randomize()

## Returns a random eligible event dict for the character, or {} if none found.
func pick_event(character: Object, task_type = null, team_characters: Array = []) -> Dictionary:
	if task_type == null:
		return {}
	var normalized_task_type := str(task_type)
	var candidates: Array = []
	for e in events:
		if (e.task == normalized_task_type or e.task == "any") and can_activate_event(e, character, team_characters):
			candidates.append(e)
	if candidates.is_empty():
		return {}
	return candidates[randi() % candidates.size()]

## 50% chance to pick an eligible event. Returns {} when no event fires.
func maybe_pick_event(character: Object, task_type = null, team_characters: Array = []) -> Dictionary:
	if task_type == null:
		return {}
	if randi() % 100 >= 50:
		return {}
	return pick_event(character, task_type, team_characters)

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
