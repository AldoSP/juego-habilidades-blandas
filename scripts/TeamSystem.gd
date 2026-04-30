extends Node

#Este es el sistema que controla las tareas que realizan los personajes

var characters = []

#La estructura de un personaje es nombre, fortaleza, debilidad

func _ready():
	var David = Character.new("David", "programming", "design")
	David.sprites = {
		"": preload("res://assets/sprites/characters/David/David.png"),
		"Feliz": preload("res://assets/sprites/characters/David/DavidFeliz.png"),
		"Preocupado": preload("res://assets/sprites/characters/David/DavidPreocupado.png"),
		"Portrait": preload("res://assets/sprites/characters/David/DavidPortrait.png"),
	}
	characters.append(David)

	var Erick = Character.new("Erick", "design", "testing")
	Erick.sprites = {
		"": preload("res://assets/sprites/characters/Erick/Erick.png"),
		"Feliz": preload("res://assets/sprites/characters/Erick/ErickFeliz.png"),
		"Preocupado": preload("res://assets/sprites/characters/Erick/ErickPreocupado.png"),
		"Portrait": preload("res://assets/sprites/characters/Erick/ErickPortrait.png"),
	}
	characters.append(Erick)

	var Jhonatan = Character.new("Jhonatan", "testing", "programming")
	Jhonatan.sprites = {
		"": preload("res://assets/sprites/characters/Jhonatan/Jhonatan.png"),
		"Feliz": preload("res://assets/sprites/characters/Jhonatan/JhonatanFeliz.png"),
		"Preocupado": preload("res://assets/sprites/characters/Jhonatan/JhonatanPreocupado.png"),
		"Portrait": preload("res://assets/sprites/characters/Jhonatan/JhonatanPortrait.png"),
	}
	characters.append(Jhonatan)

	var Karol = Character.new("Karol", "management", "management")
	Karol.sprites = {
		"": preload("res://assets/sprites/characters/Karol/Karol.png"),
		"Feliz": preload("res://assets/sprites/characters/Karol/KarolFeliz.png"),
		"Preocupado": preload("res://assets/sprites/characters/Karol/KarolPreocupada.png"),
		"Portrait": preload("res://assets/sprites/characters/Karol/KarolPortrait.png"),
	}
	characters.append(Karol)
