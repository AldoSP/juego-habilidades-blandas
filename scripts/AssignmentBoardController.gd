extends Control

var selected_character = null

@onready var start_area = $MarginContainer/VBoxContainer/StartArea
@onready var categories_container = $MarginContainer/VBoxContainer/Categories
@onready var confirm_button = $MarginContainer/VBoxContainer/TopBar/HBoxContainer/ConfirmButton
@onready var reset_button = $MarginContainer/VBoxContainer/TopBar/HBoxContainer/ResetButton

signal assignments_confirmed(assignments)

func _ready():
	# Connect reset button
	reset_button.pressed.connect(_on_reset_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)

	# Connect all character buttons
	for button in get_tree().get_nodes_in_group("character_buttons"):
		button.connect("pressed_character", _on_character_selected)

	# Connect all category containers
	for category in get_tree().get_nodes_in_group("categories"):
		category.connect("category_clicked", _on_category_clicked)

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

	# Move all buttons back to start area
	for button in get_tree().get_nodes_in_group("character_buttons"):
		button.get_parent().remove_child(button)
		start_area.add_child(button)

	# Clear selection if any
	if selected_character:
		selected_character.modulate = Color.WHITE
		selected_character = null

func _on_confirm_pressed():
	# Duplicate so external systems don’t accidentally modify it
	var result = AssignmentManager.assignments.duplicate()
	if AssignmentManager.assignments.is_empty():
		print("No assignments yet")
		return

	emit_signal("assignments_confirmed", result)

	print("Assignments confirmed: ", result)
