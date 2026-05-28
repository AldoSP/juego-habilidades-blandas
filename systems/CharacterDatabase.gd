extends Node

const CHARACTER_PATHS := [
	"res://data/characters/David.tres",
	"res://data/characters/Erick.tres",
	"res://data/characters/Jhonatan.tres",
	"res://data/characters/Karol.tres",
	"res://data/characters/Ana.tres",
	"res://data/characters/Christian.tres",
	"res://data/characters/Elizabeth.tres",
	"res://data/characters/Jessica.tres"
]

var characters: Array[Character] = []
var selected_characters: Array[Character] = []

func _ready() -> void:
	characters.clear()
	for character_path in CHARACTER_PATHS:
		var character := load(character_path) as Character
		if character != null:
			characters.append(character)
		else:
			push_warning("CharacterDatabase could not load character resource: %s" % character_path)

func set_selected_characters(new_selected_characters: Array[Character]) -> void:
	selected_characters.clear()
	for character in new_selected_characters:
		if character == null:
			continue
		selected_characters.append(character.duplicate(true))

func get_selected_characters() -> Array[Character]:
	var copies: Array[Character] = []
	for character in selected_characters:
		if character == null:
			continue
		copies.append(character.duplicate(true))
	return copies

func clear_selected_characters() -> void:
	selected_characters.clear()
