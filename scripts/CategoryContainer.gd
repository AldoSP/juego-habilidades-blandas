extends PanelContainer

signal category_clicked(category)
@onready var content = $VBoxContainer
@export var category_id: String

func _ready():
	add_to_group("categories")

func set_label(text: String):
	var label = $VBoxContainer/Label
	label.text = text

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("category_clicked", self)
