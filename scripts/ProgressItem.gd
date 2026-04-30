extends HBoxContainer

@onready var icon = $icon
@onready var label = $"progress text"

var current := 0
var target := 0
var _pending_texture: Texture2D = null

func _ready():
	if _pending_texture != null:
		icon.texture = _pending_texture
		_update_label()

func setup(icon_texture: Texture2D, target_value: int):
	target = target_value
	current = 0
	_pending_texture = icon_texture
	if is_node_ready():
		icon.texture = icon_texture
		_update_label()

func add_progress(amount: int):
	current += amount
	if current > target:
		current = target
	_update_label()

func set_progress(value: int):
	current = clamp(value, 0, target)
	_update_label()

func _update_label():
	label.text = str(current) + "/" + str(target)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	
	if current >= target:
		modulate = Color(0.6, 1, 0.6) # green-ish
	else:
		modulate = Color(1, 1, 1)
