extends Resource
class_name Character

#Esta es la estructura de un personaje

var name
var strength
var weakness
var energy = 100
var assigned_task = null

func _init(_name, _strength, _weakness):
	name = _name
	strength = _strength
	weakness = _weakness
