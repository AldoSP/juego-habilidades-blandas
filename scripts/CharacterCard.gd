extends Control

const ENERGY_UNIT := 10
const DISPLAY_ENERGY_MAX := 3

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
	var icon = $HBoxContainer/Icon
	var portrait = character.get_sprite("Portrait")
	if portrait == null:
		portrait = character.get_sprite("")
	icon.texture = portrait
	$HBoxContainer/VBoxContainer/NameLabel.text = character.name
	var energy_bar = $HBoxContainer/VBoxContainer/EnergyBar
	energy_bar.max_value = DISPLAY_ENERGY_MAX
	energy_bar.value = mini(int(character.energy / ENERGY_UNIT), DISPLAY_ENERGY_MAX)
