extends Control

signal personaje_elegido(nombre, fortaleza, debilidad, descripcion, imagen)

var nombre = ""
var fortaleza = ""
var debilidad = ""
var descripcion = ""
var imagen = null

func configurar_personaje(nuevo_nombre, nueva_fortaleza, nueva_debilidad, nueva_descripcion, nueva_imagen):
	nombre = nuevo_nombre
	fortaleza = nueva_fortaleza
	debilidad = nueva_debilidad
	descripcion = nueva_descripcion
	imagen = nueva_imagen
	$TextureButton.texture_normal = imagen

func _ready() -> void:
	$Panel.visible = false

func _on_texture_button_mouse_entered() -> void:
	$Panel.visible = true
	$Panel/Label.text = "Nombre: " + nombre + "\nFortaleza: " + fortaleza + "\nDebilidad: " + debilidad + "\nDescripción: " + descripcion

func _on_texture_button_mouse_exited() -> void:
	$Panel.visible = false

func _on_texture_button_pressed() -> void:
	print("CLICK EN: " + nombre)
	personaje_elegido.emit(nombre, fortaleza, debilidad, descripcion, imagen)
