extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		cambiar_escena()

func cambiar_escena():
	get_tree().change_scene_to_file("res://escenas/escena_trabajo.tscn")
