extends MarginContainer

@onready var programming = $PanelContainer/MarginContainer/VBoxContainer/ProgrammingItem
@onready var design = $PanelContainer/MarginContainer/VBoxContainer/DesignItem
@onready var testing = $PanelContainer/MarginContainer/VBoxContainer/TestingItem

func setup(data):
	# data example:
	# { "programming": { "current": 4, "target": 20 }, ... }
	# or flat: { "programming": 4, ... } (targets default to 20)
	var prog = data["programming"]
	var des = data["design"]
	var test = data["testing"]

	if typeof(prog) == TYPE_DICTIONARY:
		programming.setup(preload("res://assets/sprites/icons/Code.png"), prog["target"], "Programación")
		programming.set_progress(prog["current"])
		design.setup(preload("res://assets/sprites/icons/Design.png"), des["target"], "Diseño")
		design.set_progress(des["current"])
		testing.setup(preload("res://assets/sprites/icons/Bug.png"), test["target"], "Pruebas")
		testing.set_progress(test["current"])
	else:
		programming.setup(preload("res://assets/sprites/icons/Code.png"), 20, "Programación")
		programming.set_progress(prog)
		design.setup(preload("res://assets/sprites/icons/Design.png"), 20, "Diseño")
		design.set_progress(des)
		testing.setup(preload("res://assets/sprites/icons/Bug.png"), 20, "Pruebas")
		testing.set_progress(test)

func apply_assignment_result(assignments):
	# Example logic: each character contributes something
	for char_id in assignments:
		var category = assignments[char_id]

		match category:
			"programming":
				programming.add_progress(2)
			"testing":
				testing.add_progress(2)
			"design":
				design.add_progress(2)
