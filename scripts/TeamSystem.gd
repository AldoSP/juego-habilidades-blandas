extends Node

#Este es el sistema que controla las tareas que realizan los personajes

var characters = []

#La estructura de un personaje es nombre, fortaleza, debilidad

func _ready():
	if _load_selected_characters_from_database():
		return

	if not characters.is_empty():
		return

	_load_default_characters()

func _load_selected_characters_from_database() -> bool:
	if not CharacterDatabase.has_method("get_selected_characters"):
		return false

	var selected := CharacterDatabase.get_selected_characters()
	if selected.is_empty():
		return false

	set_selected_characters(selected)
	if CharacterDatabase.has_method("clear_selected_characters"):
		CharacterDatabase.clear_selected_characters()
	return true

func _load_default_characters() -> void:
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

	var Karol = Character.new("Karol", "testing", "design")
	Karol.sprites = {
		"": preload("res://assets/sprites/characters/Karol/Karol.png"),
		"Feliz": preload("res://assets/sprites/characters/Karol/KarolFeliz.png"),
		"Preocupado": preload("res://assets/sprites/characters/Karol/KarolPreocupada.png"),
		"Portrait": preload("res://assets/sprites/characters/Karol/KarolPortrait.png"),
	}
	characters.append(Karol)

func set_selected_characters(new_characters: Array) -> void:
	characters.clear()
	for character in new_characters:
		if character == null:
			continue
		characters.append(character.duplicate(true))
