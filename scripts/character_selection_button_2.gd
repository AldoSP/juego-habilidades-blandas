extends Control

signal character_hovered(character_name, strength, weakness, description, full_body_texture)
signal character_selected(character_name, face_texture)

@export_group("Datos")
@export var character_name: String = "Nombre"
@export var strength: String = "Fortaleza"
@export var weakness: String = "Debilidad"
@export_multiline var description: String = "Descripción"

@export_group("Imagenes")
@export var face_texture: Texture2D
@export var full_body_texture: Texture2D

@onready var face_button = $FaceButton

func _ready():
	face_button.texture_normal = face_texture

func _on_face_button_mouse_entered():
	character_hovered.emit(
		character_name,
		strength,
		weakness,
		description,
		full_body_texture
	)

func _on_face_button_pressed():
	character_selected.emit(character_name, face_texture)
