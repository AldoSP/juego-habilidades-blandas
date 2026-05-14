extends Control

@onready var limit_warning = $MainMargin/MainHBox/RightPanel/LimitWarning
@onready var warning_timer = $MainMargin/MainHBox/RightPanel/WarningTimer

@onready var characters_grid = $MainMargin/MainHBox/LeftPanel/CharactersGrid
@onready var preview_full_body = $MainMargin/MainHBox/PreviewPanel/PreviewFullBody
@onready var preview_info = $MainMargin/MainHBox/PreviewPanel/PreviewInfo

@onready var face_1 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot1/face1
@onready var name_1 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot1/name1

@onready var face_2 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot2/face2
@onready var name_2 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot2/name2

@onready var face_3 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot3/face3
@onready var name_3 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot3/name3

@onready var face_4 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot4/face4
@onready var name_4 = $MainMargin/MainHBox/RightPanel/SelectedSlots/slot4/name4

var selected_characters = []

func _ready():
	for child in characters_grid.get_children():
		if child.has_signal("character_hovered"):
			child.character_hovered.connect(_on_character_hovered)
		if child.has_signal("character_selected"):
			child.character_selected.connect(_on_character_selected)

	_update_selected_slots()
	limit_warning.hide()

func _on_character_hovered(character_name, strength, weakness, description, full_body_texture):
	preview_full_body.texture = full_body_texture
	preview_info.text = "[center][font_size=28]" + character_name + "[/font_size]\n\nFortaleza: " + strength + "\nDebilidad: " + weakness + "\n" + description + "[/center]"

func _on_character_selected(character_name, face_texture):
	for character in selected_characters:
		if character["name"] == character_name:
			return

	if selected_characters.size() >= 4:
		limit_warning.show()
		warning_timer.start()
		return

	selected_characters.append({
		"name": character_name,
		"face": face_texture
	})

	_update_selected_slots()

func _update_selected_slots():
	face_1.texture = null
	name_1.text = "Vacío"

	face_2.texture = null
	name_2.text = "Vacío"

	face_3.texture = null
	name_3.text = "Vacío"

	face_4.texture = null
	name_4.text = "Vacío"

	if selected_characters.size() > 0:
		face_1.texture = selected_characters[0]["face"]
		name_1.text = selected_characters[0]["name"]

	if selected_characters.size() > 1:
		face_2.texture = selected_characters[1]["face"]
		name_2.text = selected_characters[1]["name"]

	if selected_characters.size() > 2:
		face_3.texture = selected_characters[2]["face"]
		name_3.text = selected_characters[2]["name"]

	if selected_characters.size() > 3:
		face_4.texture = selected_characters[3]["face"]
		name_4.text = selected_characters[3]["name"]
		

func _on_warning_timer_timeout() -> void:
		limit_warning.hide()

func _on_ready_button_pressed() -> void:
	pass # Replace with function body.

func _on_clear_button_pressed() -> void:
	selected_characters.clear()
	_update_selected_slots()
