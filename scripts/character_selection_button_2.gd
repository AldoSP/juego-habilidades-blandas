extends Control

signal character_hovered(character)
signal character_selected(character)

@export_group("Datos")
@export var character_name: String = "Nombre"
@export var strength: String = "Fortaleza"
@export var weakness: String = "Debilidad"
@export_multiline var description: String = "Descripción"

@export_group("Imagenes")
@export var face_texture: Texture2D
@export var full_body_texture: Texture2D

var character: Character

@onready var face_button = $FaceButton

func _ready():
	if character == null:
		character = _build_character_from_exports()
	_prepare_visuals()

func setup(new_character: Character):
	character = new_character
	if character == null:
		return

	character_name = character.name
	strength = str(character.strength)
	weakness = str(character.weakness)
	description = str(character.description)
	face_texture = character.get_sprite("Portrait")
	if face_texture == null:
		face_texture = character.get_sprite()
	full_body_texture = character.get_sprite()
	_prepare_visuals()

func _prepare_visuals():
	if is_instance_valid(face_button):
		face_button.texture_normal = face_texture

func _build_character_from_exports() -> Character:
	var exported_character := Character.new(character_name, strength, weakness)
	exported_character.description = description
	exported_character.sprites = {
		"": full_body_texture,
		"Portrait": face_texture
	}
	return exported_character

func _on_face_button_mouse_entered():
	if character == null:
		return
	character_hovered.emit(character)

func _on_face_button_mouse_exited():
	pass

func _on_face_button_pressed():
	if character == null:
		return
	character_selected.emit(character)
