extends Control

var character = null

func _ready():
	custom_minimum_size = Vector2(150, 100)

func set_character(char):
	character = char
	character.energy_changed.connect(update_ui)
	update_ui()

func update_ui():
	if character == null:
		print("Character is null")
		return
	$HBoxContainer/VBoxContainer/NameLabel.text = character.name
	$HBoxContainer/VBoxContainer/EnergyBar.value = character.energy
