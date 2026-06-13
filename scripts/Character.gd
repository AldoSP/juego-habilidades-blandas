extends Resource
class_name Character

#Esta es la estructura de un personaje

const MAX_ENERGY := 30

@export var name: String = ""
@export var strength: String = ""
@export var weakness: String = ""
@export var energy: int = MAX_ENERGY
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
	energy = clamp(value, 0, MAX_ENERGY)
	print("Energía cambió a: ", energy)
	emit_signal("energy_changed")
