extends Control
class_name CharacterAssignment

# Referencia al personaje
var character_name: String
var assigned_task: String = null
var character_data: Character

# Variables de animación
var is_dragging = false
var drag_offset = Vector2.ZERO
var original_position = Vector2.ZERO

signal selected(character_name: String)
signal task_assigned(character_name: String, task_name: String)

func _ready():
	modulate = Color.WHITE
	custom_minimum_size = Vector2(100, 80)

func set_character(char_data: Character):
	character_data = char_data
	character_name = char_data.name
	
	# Actualizar visualización
	$Label.text = char_data.name
	update_appearance()

func assign_to_task(task_name: String):
	"""Asigna el personaje a una tarea con animación"""
	assigned_task = task_name
	
	# Encontrar el nodo destino (área de la tarea)
	var task_area = get_parent().get_parent().find_child(task_name + "_Area", true, false)
	
	if task_area:
		# Guardar posición original
		original_position = position
		
		# Animar el movimiento
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", task_area.position - position + task_area.size / 2, 0.6)
		
		# Cambiar apariencia
		await tween.finished
		update_appearance()
		print(character_name, " asignado a ", task_name)
		task_assigned.emit(character_name, task_name)

func update_appearance():
	"""Actualiza el color y aspecto según el estado"""
	if assigned_task:
		modulate = Color.from_string("a8ff69ff", Color.WHITE)  # Verde claro
		$Label.text = character_name + "\n(" + assigned_task + ")"
	else:
		modulate = Color.from_string("6ba3ffff", Color.WHITE)  # Azul claro
		$Label.text = character_name

func _on_pressed():
	"""Se llama cuando se hace click en el personaje"""
	selected.emit(character_name)
	print("Seleccionado: ", character_name)
