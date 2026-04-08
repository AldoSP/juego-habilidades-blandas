extends Sprite2D

var arrastrando = false

func _input(event):
	# Cuando haces clic
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if get_rect().has_point(to_local(event.position)):
				arrastrando = true
		
		# Cuando sueltas clic
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			arrastrando = false

func _process(delta):
	if arrastrando:
		global_position = get_global_mouse_position()
