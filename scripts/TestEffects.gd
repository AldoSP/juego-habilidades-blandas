extends Control
## Escena de prueba para EffectsLayer
## Muestra una pregunta con opciones Sí/No y efectos visuales según la respuesta

class_name TestEffects

@onready var question_label = $VBoxContainer/QuestionLabel
@onready var yes_button = $VBoxContainer/ButtonContainer/YesButton
@onready var no_button = $VBoxContainer/ButtonContainer/NoButton

var effects_layer: CanvasLayer
var questions = [
	"¿Te gusta programar?",
	"¿Completaste la tarea a tiempo?",
	"¿El código está bien documentado?",
	"¿Pasó todas las pruebas?",
	"¿El diseño es intuitivo?",
]
var current_question_index = 0

func _ready():
	# Obtener referencia a la capa de efectos
	effects_layer = get_tree().root.find_child("EffectsLayer", true, false)
	if effects_layer == null:
		print("⚠ EffectsLayer no encontrada en el árbol. Creando una nueva...")
		var effects_scene = load("res://escenas/effects_layer.tscn")
		effects_layer = effects_scene.instantiate()
		effects_layer.name = "EffectsLayer"
		get_tree().root.call_deferred("add_child", effects_layer)
	
	print("✓ Escena de prueba cargada correctamente")
	
	# Conectar botones
	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	
	# Mostrar primera pregunta
	_show_next_question()

func _show_next_question():
	if current_question_index >= questions.size():
		question_label.text = "¡Prueba completada! Presiona Sí para reiniciar."
		current_question_index = 0
		return
	
	question_label.text = questions[current_question_index]
	current_question_index += 1

func _on_yes_pressed():
	var center = get_viewport().get_visible_rect().get_center()
	
	# Mostrar efecto positivo
	effects_layer.show_positive_feedback(center, 8)
	
	# Esperar un poco y mostrar la siguiente pregunta
	await get_tree().create_timer(0.8).timeout
	_show_next_question()

func _on_no_pressed():
	var center = get_viewport().get_visible_rect().get_center()
	
	# Mostrar efecto negativo
	effects_layer.show_negative_feedback(center, 8)
	
	# Esperar un poco y mostrar la siguiente pregunta
	await get_tree().create_timer(0.8).timeout
	_show_next_question()
