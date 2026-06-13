extends Control

const CHARACTER_BUTTON_SCENE = preload("res://escenas/character_Selection_Button_2.tscn")
const MAIN_GAME_SCENE := "res://escenas/main_game.tscn"

const SKILL_LABELS := {
	"programming": "Programación",
	"design": "Diseño",
	"testing": "Pruebas"
}

@onready var limit_warning = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/LimitWarning
@onready var warning_timer = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/WarningTimer

@onready var characters_grid = $MainMargin/PanelContainer/MainHBox/LeftContainer/MarginContainer/LeftPanel/CharactersGrid
@onready var preview_full_body = $MainMargin/PanelContainer/MainHBox/PreviewContainer/MarginContainer/PreviewPanel/PreviewFullBody
@onready var preview_info = $MainMargin/PanelContainer/MainHBox/PreviewContainer/MarginContainer/PreviewPanel/PreviewInfo

@onready var face_1 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot1/face1
@onready var name_1 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot1/name1

@onready var face_2 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot2/face2
@onready var name_2 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot2/name2

@onready var face_3 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot3/face3
@onready var name_3 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot3/name3

@onready var face_4 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot4/face4
@onready var name_4 = $MainMargin/PanelContainer/MainHBox/RightContainer/MarginContainer/RightPanel/SelectedSlots/slot4/name4

var selected_characters: Array[Character] = []

func _ready() -> void:
	_populate_character_buttons()
	for child in characters_grid.get_children():
		if child.has_signal("character_hovered"):
			child.character_hovered.connect(_on_character_hovered)
		if child.has_signal("character_selected"):
			child.character_selected.connect(_on_character_selected)

	_update_selected_slots()
	_clear_preview()
	limit_warning.hide()

func _populate_character_buttons() -> void:
	for child in characters_grid.get_children():
		characters_grid.remove_child(child)
		child.queue_free()

	for character in CharacterDatabase.characters:
		if character == null:
			continue

		var button = CHARACTER_BUTTON_SCENE.instantiate()
		button.setup(character)
		characters_grid.add_child(button)

func _on_character_hovered(character: Character):
	if character == null:
		return

	preview_full_body.texture = _get_full_body_texture(character)
	preview_info.text = "[center][font_size=28]" + character.name + "[/font_size]\n\nFortaleza: " + _skill_label(character.strength) + "\nDebilidad: " + _skill_label(character.weakness) + "\n" + str(character.description) + "[/center]"

func _on_character_selected(character: Character):
	if character == null:
		return

	for selected_character in selected_characters:
		if selected_character.name == character.name:
			return

	if selected_characters.size() >= 4:
		limit_warning.show()
		warning_timer.start()
		return

	var selected_character := character.duplicate(true) as Character
	if selected_character == null:
		return

	selected_characters.append(selected_character)
	_sync_team_system_characters()

	_update_selected_slots()

func _update_selected_slots() -> void:
	face_1.texture = null
	name_1.text = "Vacío"

	face_2.texture = null
	name_2.text = "Vacío"

	face_3.texture = null
	name_3.text = "Vacío"

	face_4.texture = null
	name_4.text = "Vacío"

	if selected_characters.size() > 0:
		face_1.texture = _get_face_texture(selected_characters[0])
		name_1.text = selected_characters[0].name

	if selected_characters.size() > 1:
		face_2.texture = _get_face_texture(selected_characters[1])
		name_2.text = selected_characters[1].name

	if selected_characters.size() > 2:
		face_3.texture = _get_face_texture(selected_characters[2])
		name_3.text = selected_characters[2].name

	if selected_characters.size() > 3:
		face_4.texture = _get_face_texture(selected_characters[3])
		name_4.text = selected_characters[3].name

func _skill_label(skill: String) -> String:
	return SKILL_LABELS.get(skill.to_lower(), skill)

func _get_face_texture(character: Character) -> Texture2D:
	if character == null:
		return null

	var portrait = character.get_sprite("Portrait")
	if portrait != null:
		return portrait

	return character.get_sprite()

func _get_full_body_texture(character: Character) -> Texture2D:
	if character == null:
		return null
	return character.get_sprite()

func _clear_preview() -> void:
	preview_full_body.texture = null
	preview_info.text = ""
		

func _on_warning_timer_timeout() -> void:
		limit_warning.hide()

func _on_ready_button_pressed() -> void:
	CharacterDatabase.set_selected_characters(selected_characters)
	_sync_team_system_characters()
	var change_scene_result := get_tree().change_scene_to_file(MAIN_GAME_SCENE)
	if change_scene_result != OK:
		push_error("Failed to load scene: %s" % MAIN_GAME_SCENE)

func _on_clear_button_pressed() -> void:
	selected_characters.clear()
	_sync_team_system_characters()
	_update_selected_slots()
	_clear_preview()

func _sync_team_system_characters() -> void:
	var team_system = get_tree().root.find_child("TeamSystem", true, false)
	if team_system == null:
		return

	if team_system.has_method("set_selected_characters"):
		team_system.set_selected_characters(selected_characters)
		return

	team_system.characters.clear()
	for character in selected_characters:
		team_system.characters.append(character.duplicate(true))
