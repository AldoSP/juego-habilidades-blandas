extends Resource
class_name Character

#Esta es la estructura de un personaje

var name
var strength
var weakness
var energy = 100
var assigned_task = null
var task_modifier = 0
var event_description = ""
var sprites: Dictionary = {}
var description
signal energy_changed
	
func _init(_name, _strength, _weakness):
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
