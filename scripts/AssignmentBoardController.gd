extends Control

var selected_character = null

const CharacterButtonScene = preload("res://escenas/character_button.tscn")
const CategoryContainerScene = preload("res://escenas/category_container.tscn")

@onready var start_area = $MarginContainer/VBoxContainer/StartArea
@onready var categories_container = $MarginContainer/VBoxContainer/Categories
@onready var confirm_button = $MarginContainer/VBoxContainer/TopBar/HBoxContainer/ConfirmButton
@onready var reset_button = $MarginContainer/VBoxContainer/TopBar/HBoxContainer/ResetButton



@export var characters_data = [

]

@export var categories_data = [

]

signal assignments_confirmed(assignments)

func setup_board(characters, categories):
	characters_data = characters
	categories_data = categories
	AssignmentManager.reset()

	load_categories()
	load_characters()


func load_categories():
	# Clear existing (in case of reload)
	for child in categories_container.get_children():
		child.queue_free()

	for data in categories_data:
		var category = CategoryContainerScene.instantiate()
		
		category.category_id = data["id"]
		
		
		category.set_label(data["label"])

		categories_container.add_child(category)

		# Connect signal
		category.connect("category_clicked", _on_category_clicked)
		

func load_characters():
	for child in start_area.get_children():
		child.queue_free()

	for data in characters_data:
		var button = CharacterButtonScene.instantiate()
		
		button.character_id = data["id"]
		button.text = data["name"]

		start_area.add_child(button)

		# Connect signal
		button.connect("pressed_character", _on_character_selected)

func _ready():
	# Connect reset button
	reset_button.pressed.connect(_on_reset_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_character_selected(button):
	if selected_character and selected_character != button:
		selected_character.set_selected(false)

	selected_character = button
	selected_character.set_selected(true)

func _animate_select(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.15, 1.15), 0.15)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func _reset_button_visual(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1, 1), 0.1)
	button.modulate = Color.WHITE

func _on_category_clicked(category):
	if selected_character == null:
		return

	var button = selected_character  # store reference safely

	# Move visually
	button.get_parent().remove_child(button)
	category.content.add_child(button)

	# Update manager
	AssignmentManager.assign(button.character_id, category.category_id)

	# Reset visual state BEFORE clearing
	button.set_selected(false)

	# Now clear selection
	selected_character = null

func _on_reset_pressed():
	AssignmentManager.reset()

	# 🔹 Remove ALL existing character buttons (no matter where they are)
	for button in get_tree().get_nodes_in_group("character_buttons"):
		button.queue_free()

	# 🔹 Clear selection safely
	if selected_character:
		selected_character = null

	# 🔹 Reload fresh
	load_characters()

func _on_confirm_pressed():
	# Duplicate so external systems don’t accidentally modify it
	var result = AssignmentManager.assignments.duplicate()
	if AssignmentManager.assignments.is_empty():
		print("No assignments yet")
		return

	emit_signal("assignments_confirmed", result)

	print("Assignments confirmed: ", result)
