extends Node

#Este es el sistema que controla las tareas que realizan los personajes

var characters = []

#La estructura de un personaje es nombre, fortaleza, debilidad

func _ready():
	characters.append(Character.new("Ana", "programming", "design"))
	characters.append(Character.new("Mateo", "design", "testing"))
	characters.append(Character.new("Sofia", "testing", "programming"))
