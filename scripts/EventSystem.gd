extends Node

## Each entry maps a Dialogic timeline ID to its activation conditions.
## The timeline ID must match the identifier used in Dialogic.start().

var events: Array = [
	{
		"id": "res://dialogic/timelines/events/Event_Feedback sorpresa.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Ana", "David"],
			"required_team_characters": ["Ana", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_El correo urgente.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Christian", "Elizabeth"],
			"required_team_characters": ["Christian", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Duda en la reunión.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Erick", "Jessica"],
			"required_team_characters": ["Erick", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_La prueba de creatividad.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Karol"],
			"required_team_characters": ["Ana", "Karol"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_El proyecto al límite.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "David"],
			"required_team_characters": ["Jhonatan", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_El conflicto de prioridades.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Elizabeth", "Christian"],
			"required_team_characters": ["Elizabeth", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_La idea de Jessica.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Jessica", "Erick"],
			"required_team_characters": ["Jessica", "Erick"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_La visita del cliente.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Elizabeth"],
			"required_team_characters": ["Ana", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_El reto de Karol.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Jhonatan"],
			"required_team_characters": ["Karol", "Jhonatan"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_El error en el informe.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David", "Christian"],
			"required_team_characters": ["David", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_La decisión de equipo.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jessica", "Erick", "Elizabeth"],
			"required_team_characters": ["Jessica", "Erick", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Bug crítico.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Christian", "David"],
			"required_team_characters": ["Christian", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Diseño rechazado.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Elizabeth"],
			"required_team_characters": ["Karol", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Testing incompleto.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "Jessica"],
			"required_team_characters": ["Jhonatan", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_El código heredado.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David", "Christian"],
			"required_team_characters": ["David", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Refactorización urgente.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Elizabeth", "Erick"],
			"required_team_characters": ["Elizabeth", "Erick"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Interfaz complicada.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Karol"],
			"required_team_characters": ["Ana", "Karol"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Casos no cubiertos.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jessica", "David"],
			"required_team_characters": ["Jessica", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Performance lento.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Christian", "Jhonatan"],
			"required_team_characters": ["Christian", "Jhonatan"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Cambio de requisitos.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Elizabeth"],
			"required_team_characters": ["Ana", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Deuda técnica.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Erick", "Karol"],
			"required_team_characters": ["Erick", "Karol"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Validación de datos.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David", "Jessica"],
			"required_team_characters": ["David", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Paleta de colores.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Elizabeth"],
			"required_team_characters": ["Karol", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Cobertura de tests.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "Christian"],
			"required_team_characters": ["Jhonatan", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Integración fallida.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Erick"],
			"required_team_characters": ["Ana", "Erick"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Diseño responsive.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "David"],
			"required_team_characters": ["Karol", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Script quebrado.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Christian", "Jessica"],
			"required_team_characters": ["Christian", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Documentación faltante.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Elizabeth", "Ana"],
			"required_team_characters": ["Elizabeth", "Ana"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Ambiente de producción.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "Karol"],
			"required_team_characters": ["Jhonatan", "Karol"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Animaciones suaves.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Elizabeth"],
			"required_team_characters": ["Karol", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Seguridad en código.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David", "Christian"],
			"required_team_characters": ["David", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Prueba de estrés.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "Jessica"],
			"required_team_characters": ["Jhonatan", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Accesibilidad.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Karol"],
			"required_team_characters": ["Ana", "Karol"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Logs y depuración.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Christian", "David"],
			"required_team_characters": ["Christian", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Usuario se confunde.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Elizabeth"],
			"required_team_characters": ["Karol", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Escalabilidad cuestionada.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "Elizabeth"],
			"required_team_characters": ["Jhonatan", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Tipografía inconsistente.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Ana"],
			"required_team_characters": ["Karol", "Ana"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Edge cases.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jessica", "Erick"],
			"required_team_characters": ["Jessica", "Erick"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_API lenta.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Christian", "Jhonatan"],
			"required_team_characters": ["Christian", "Jhonatan"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Contraste visual.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Elizabeth"],
			"required_team_characters": ["Karol", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Código duplicado.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["David", "Jessica"],
			"required_team_characters": ["David", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Mock de datos.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Erick", "Christian"],
			"required_team_characters": ["Erick", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Experiencia vs Función.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Ana"],
			"required_team_characters": ["Karol", "Ana"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Manejo de errores.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Jhonatan", "David"],
			"required_team_characters": ["Jhonatan", "David"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Feedback del diseñador.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Elizabeth"],
			"required_team_characters": ["Karol", "Elizabeth"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Base de datos creciendo.dtl",
		"task": "programming",
		"activation_conditions": {
			"allowed_characters": ["Christian", "Jhonatan"],
			"required_team_characters": ["Christian", "Jhonatan"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Flujo de usuario confuso.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Karol", "Jessica"],
			"required_team_characters": ["Karol", "Jessica"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Unit test falló.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["David", "Erick"],
			"required_team_characters": ["David", "Erick"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Feedback en producción.dtl",
		"task": "design",
		"activation_conditions": {
			"allowed_characters": ["Ana", "Christian"],
			"required_team_characters": ["Ana", "Christian"]
		}
	},
	{
		"id": "res://dialogic/timelines/events/Event_Sprint final.dtl",
		"task": "testing",
		"activation_conditions": {
			"allowed_characters": ["Jessica", "Jhonatan", "Elizabeth"],
			"required_team_characters": ["Jessica", "Jhonatan", "Elizabeth"]
		}
	},
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
