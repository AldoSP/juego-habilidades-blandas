extends Control

const INTRO_TIMELINE_ID := "Introduction"
const MAIN_GAME_SCENE := "res://escenas/main_game.tscn"

var _intro_started := false


func _ready() -> void:
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)


func _exit_tree() -> void:
	if Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)


func _on_texture_button_pressed() -> void:
	if _intro_started:
		return

	_intro_started = true
	Dialogic.start(INTRO_TIMELINE_ID)


func _on_dialogic_timeline_ended() -> void:
	if not _intro_started:
		return

	get_tree().change_scene_to_file(MAIN_GAME_SCENE)
