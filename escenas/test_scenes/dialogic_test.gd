extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("res://dialogic/testtimeline.dtl")
	get_viewport().set_input_as_handled()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
