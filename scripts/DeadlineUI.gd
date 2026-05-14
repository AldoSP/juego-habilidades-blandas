extends MarginContainer

signal deadline_reached

@onready var value_label = $PanelContainer/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/Value

var days_remaining := 10

func setup(initial_days: int):
	days_remaining = initial_days
	_update_label()

func advance_day(amount: int = 1):
	days_remaining -= amount
	if days_remaining < 0:
		days_remaining = 0
	
	_update_label()

	if days_remaining == 0:
		emit_signal("deadline_reached")

func _update_label():
	if value_label == null:
		return

	value_label.text = str(days_remaining)

	# Optional visual feedback
	if days_remaining <= 3:
		value_label.modulate = Color(1, 0.5, 0.5) # red-ish
	else:
		value_label.modulate = Color(1, 1, 1)
