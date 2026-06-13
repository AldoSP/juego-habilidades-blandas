extends Control

const INTRO_TIMELINE_ID := "Introduction"
const TUTORIAL_TIMELINE_ID := "tutorial"
const START_SCENE := "res://escenas/character_Selection_2.tscn"

var _active_timeline := ""


func _ready() -> void:
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)


func _exit_tree() -> void:
	if Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)


func _on_dialogic_timeline_ended() -> void:
	if _active_timeline.is_empty():
		return

	if _active_timeline == INTRO_TIMELINE_ID:
		get_tree().change_scene_to_file(START_SCENE)

	_active_timeline = ""

# ---------------------------- SIGNALS ----------------------------------
func _on_play_button_pressed() -> void:
	if not _active_timeline.is_empty():
		return

	_active_timeline = INTRO_TIMELINE_ID
	Dialogic.start(INTRO_TIMELINE_ID)


func _on_tutorial_button_pressed() -> void:
	if not _active_timeline.is_empty():
		return

	_active_timeline = TUTORIAL_TIMELINE_ID
	Dialogic.start(TUTORIAL_TIMELINE_ID)


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
