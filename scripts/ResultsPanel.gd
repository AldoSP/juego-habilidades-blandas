extends Control

signal continue_pressed

@onready var programming_label = $MarginContainer/VBoxContainer/ProgrammingLabel
@onready var design_label = $MarginContainer/VBoxContainer/DesignLabel
@onready var testing_label = $MarginContainer/VBoxContainer/TestingLabel
@onready var summary_text = $MarginContainer/VBoxContainer/SummaryText
@onready var continue_button = $MarginContainer/VBoxContainer/ContinueButton

var typing_speed := 0.02
var line_delay := 0.4

var is_typing := false
var skip_typing := false


func _ready():
	continue_button.pressed.connect(_on_continue_pressed)

	# Default text so scene works standalone
	set_results(0, 0, 0)


func set_results(programming: int, design: int, testing: int):
	programming_label.text = "Programación: %d" % programming
	design_label.text = "Diseño: %d" % design
	testing_label.text = "Testing: %d" % testing


func set_summary(summary_lines: Array[String]):
	if is_typing:
		return

	if summary_lines.is_empty():
		summary_text.text = "No hubo eventos hoy."
		return

	_play_typewriter(summary_lines)


func _play_typewriter(summary_lines: Array[String]) -> void:
	is_typing = true
	skip_typing = false

	continue_button.disabled = true

	summary_text.text = ""

	for line in summary_lines:
		await _type_line(line)
		summary_text.text += "\n"

		if not skip_typing:
			await get_tree().create_timer(line_delay).timeout

	is_typing = false
	continue_button.disabled = false


func _type_line(text: String) -> void:
	for i in text.length():
		if skip_typing:
			summary_text.text += text.substr(i)
			return

		summary_text.text += text[i]

		await get_tree().create_timer(typing_speed).timeout


func add_summary_line(text: String):
	if summary_text.text == "No hubo eventos hoy.":
		summary_text.text = text
	else:
		summary_text.text += "\n" + text


func _input(event):
	if is_typing and event.is_action_pressed("ui_accept"):
		skip_typing = true


func _on_continue_pressed():
	continue_pressed.emit()
	hide()
