extends Control

var personajes_seleccionados = []
var max_personajes_seleccionados = 4
var escena_boton_personaje = preload("res://escenas/characterSelectionButton.tscn")

var personajes = [
	{
		"nombre": "Ana",
		"fortaleza": "code",
		"debilidad": "debugging",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Ana/AnaPortrait.png")
	},
	{
		"nombre": "Christian",
		"fortaleza": "code",
		"debilidad": "debugging",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Christian/ChristianPortrait.png")
	},
	{
		"nombre": "David",
		"fortaleza": "code",
		"debilidad": "diseño",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/David/DavidPortrait.png")
	},
	{
		"nombre": "Elizabeth",
		"fortaleza": "diseño",
		"debilidad": "code",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Elizabeth/ElizabethPortrait.png")
	},
	{
		"nombre": "Erick",
		"fortaleza": "code",
		"debilidad": "debugging",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Erick/ErickPortrait.png")
	},
	{
		"nombre": "Jessica",
		"fortaleza": "debugging",
		"debilidad": "Code",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Jessica/JessicaPortrait.png")
	},
	{
		"nombre": "Jhonathan",
		"fortaleza": "debugging",
		"debilidad": "diseño",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Jhonatan/JhonatanPortrait.png")
	},
	{
		"nombre": "Karol",
		"fortaleza": "diseño",
		"debilidad": "code",
		"descripcion": "Lorem ipsum",
		"imagen": preload("res://assets/sprites/characters/Karol/KarolPortrait.png")
	}
]
func _ready() -> void:
	for personaje in personajes:
		var nuevo_boton = escena_boton_personaje.instantiate()
		nuevo_boton.configurar_personaje(
			personaje["nombre"],
			personaje["fortaleza"],
			personaje["debilidad"],
			personaje["descripcion"],
			personaje["imagen"]
		)
		nuevo_boton.personaje_elegido.connect(_on_personaje_elegido)
		$MarginContainer/HBoxContainer/GridDisponibles.add_child(nuevo_boton)


func _on_personaje_elegido(nombre, fortaleza, debilidad, descripcion, imagen) -> void:
	if personajes_seleccionados.has(nombre):
		print(nombre + " ya fue seleccionado")
		return

	if personajes_seleccionados.size() >= max_personajes_seleccionados:
		print("Ya llegaste al límite de selección")
		return

	personajes_seleccionados.append(nombre)
	print("Elegiste a: " + nombre)

	var boton_seleccionado = escena_boton_personaje.instantiate()
	boton_seleccionado.configurar_personaje(nombre, fortaleza, debilidad, descripcion, imagen)

	get_node("MarginContainer/HBoxContainer/SeleccionadosContainer").add_child(boton_seleccionado)
