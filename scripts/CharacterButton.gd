extends Button

signal pressed_character(button)

@export var character_id: String

var is_selected := false

func _ready():
	add_to_group("character_buttons")

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _pressed():
	emit_signal("pressed_character", self)

func _on_mouse_entered():
	if not is_selected:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)

func _on_mouse_exited():
	if not is_selected:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), 0.1)

func set_selected(value: bool):
	is_selected = value

	var tween = create_tween()

	if value:
		tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.15)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
