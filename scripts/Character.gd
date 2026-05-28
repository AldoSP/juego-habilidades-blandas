extends Resource
class_name Character

#Esta es la estructura de un personaje

@export var name: String = ""
@export var strength: String = ""
@export var weakness: String = ""
@export var energy: int = 100
@export var assigned_task: Variant = null
@export var task_modifier: int = 0
@export_multiline var event_description: String = ""
@export var sprites: Dictionary = {}
@export_multiline var description: String = ""
signal energy_changed
	
func _init(_name: String = "", _strength: String = "", _weakness: String = ""):
	name = _name
	strength = _strength
	weakness = _weakness

func get_sprite(state: String = "") -> Texture2D:
	if sprites.has(state):
		return sprites[state]
	if sprites.has(""):
		return sprites[""]
	return null

func set_energy(value):
	energy = value
	print("Energía cambió a: ", energy)
	emit_signal("energy_changed")
