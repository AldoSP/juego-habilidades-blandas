extends VBoxContainer

signal pressed_character(button)

@export var character_id: String
@export var character_texture: Texture2D
@export var character_name: String = ""
@export var name_label_style: StyleBox

var is_selected := false
var name_label: Label
var texture_button: TextureButton

func _ready():
	add_to_group("character_buttons")
	
	# Get reference to the TextureButton named "CharacterButton"
	texture_button = get_node("CharacterButton")
	
	# Create or get the name label inside the VBoxContainer
	if get_child_count() < 2:
		name_label = Label.new()
		add_child(name_label)
	else:
		name_label = get_child(1) as Label
	
	if character_name == "" and character_id != "":
		character_name = character_id.capitalize()
	
	name_label.text = character_name
	if name_label_style:
		name_label.add_theme_stylebox_override("normal", name_label_style)
	
	# Set texture if provided
	if character_texture:
		texture_button.texture_normal = character_texture
	
	texture_button.mouse_entered.connect(_on_mouse_entered)
	texture_button.mouse_exited.connect(_on_mouse_exited)
	texture_button.pressed.connect(_on_pressed)

func _on_pressed():
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
