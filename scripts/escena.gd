extends Node2D

var dialogos = [
	{"nombre": "NombrePersonaje", "texto": "Hola... ¿estás ahí?"},
	{"nombre": "NombrePersonaje", "texto": "Este es nuestro primer diálogo."},
	{"nombre": "NombrePersonaje", "texto": "Vamos a cambiar de escena pronto..."}
]

var indice = 0

@onready var texto = $UI/CajaDialogo/Texto
@onready var nombre = $UI/CajaDialogo/Nombre

func _ready():
	mostrar_dialogo()

func mostrar_dialogo():
	nombre.text = dialogos[indice]["nombre"]
	texto.text = dialogos[indice]["texto"]

func _input(event):
	if event.is_action_pressed("ui_accept"):
		indice += 1
		
		if indice < dialogos.size():
			mostrar_dialogo()
		else:
			cambiar_escena()

func cambiar_escena():
	get_tree().change_scene_to_file("res://escenas/escena_2.tscn")
