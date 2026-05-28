extends CanvasLayer
## Capa de efectos visuales que se superpone sobre los timelines de Dialogic
## Maneja destellos, brillos y otras animaciones visuales de retroalimentación

class_name EffectsLayer

# Assets de efecto personalizables
@export var positive_effect_scene: PackedScene = preload("res://escenas/effects/asset_sparkle.tscn")
@export var negative_effect_scene: PackedScene = preload("res://escenas/effects/asset_sparkle.tscn")
@export var neutral_effect_scene: PackedScene = preload("res://escenas/effects/asset_sparkle.tscn")

# Constantes para los efectos
const GLOW_BURST_DURATION = 1.5
const SPARKLE_DURATION = 2.0

func _ready():
	# Asegurar que esta capa esté por encima de los timelines
	layer = 10

## Muestra un efecto de destellos brillantes (para decisiones buenas/puntos positivos)
func show_positive_feedback(position: Vector2, intensity: int = 5):
	"""
	Muestra checks verdes para retroalimentación positiva
	"""
	for i in range(intensity):
		_spawn_sign_effect(position, "✓", Color.GREEN, randf_range(0.8, 1.2))

## Muestra un efecto de brillo rojo (para decisiones malas/puntos negativos)
func show_negative_feedback(position: Vector2, intensity: int = 5):
	"""
	Muestra equis rojas para retroalimentación negativa
	"""
	for i in range(intensity):
		_spawn_sign_effect(position, "x", Color.RED, randf_range(0.8, 1.2))

## Muestra un efecto de brillo azul (para eventos neutrales/informativos)
func show_neutral_feedback(position: Vector2, intensity: int = 5):
	"""
	Muestra destellos de efecto personalizado con asset para retroalimentación neutral
	"""
	if neutral_effect_scene:
		for i in range(intensity):
			_spawn_asset_sparkle(position, neutral_effect_scene, randf_range(0.6, 1.2), Color.CYAN)
	else:
		for i in range(intensity):
			_spawn_sparkle(position, Color.CYAN, randf_range(0.8, 1.2))

	"""
	Muestra destellos azules para retroalimentación neutral
	
	Args:
		position: Posición en pantalla donde mostrar el efecto
		intensity: Cantidad de destellos (por defecto 5)
	"""
	for i in range(intensity):
		_spawn_sparkle(position, Color.CYAN, randf_range(0.8, 1.2))

## Muestra un efecto de resplandor expansivo
func show_glow_burst(position: Vector2, color: Color = Color.YELLOW):
	"""
	Muestra un efecto de resplandor que se expande desde el centro
	
	Args:
		position: Posición central del efecto
		color: Color del resplandor
	"""
	var burst = Node.new()
	var circle = ColorRect.new()
	circle.color = color
	circle.size = Vector2(20, 20)
	circle.position = position - circle.size / 2
	burst.add_child(circle)
	add_child(burst)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	# Expandir desde el centro
	tween.tween_property(circle, "scale", Vector2(3, 3), GLOW_BURST_DURATION)
	# Desvanecerse
	tween.tween_property(circle, "modulate:a", 0.0, GLOW_BURST_DURATION)
	
	await tween.finished
	burst.queue_free()

## Muestra un destello rápido en una posición
func show_quick_flash(position: Vector2, color: Color = Color.WHITE, duration: float = 0.3):
	"""
	Muestra un destello rápido (parpadeo)
	
	Args:
		position: Posición del destello
		color: Color del destello
		duration: Duración del destello en segundos
	"""
	var flash = ColorRect.new()
	flash.color = color
	flash.size = Vector2(40, 40)
	flash.position = position - flash.size / 2
	flash.modulate.a = 0.8
	add_child(flash)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(flash, "modulate:a", 0.0, duration)
	
	await tween.finished
	flash.queue_free()

## Muestra múltiples efectos en círculo
func show_circular_burst(center: Vector2, effect_count: int = 8, color: Color = Color.GOLD):
	"""
	Muestra múltiples destellos distribuidos en círculo
	
	Args:
		center: Posición central del efecto
		effect_count: Cantidad de efectos a mostrar
		color: Color de los efectos
	"""
	var angle_step = TAU / effect_count
	
	for i in range(effect_count):
		var angle = i * angle_step
		var effect_offset = Vector2(cos(angle), sin(angle)) * 80
		var effect_position = center + effect_offset
		_spawn_sparkle(effect_position, color, 1.0)

## Efecto de éxito con animación compleja
func show_success_effect(position: Vector2):
	"""
	Muestra un efecto complejo para indicar éxito
	(Requiere show_positive_feedback, destellos y un brillo expansivo)
	
	Args:
		position: Posición donde mostrar el efecto
	"""
	show_glow_burst(position, Color.GOLD)
	show_positive_feedback(position, 8)
	await get_tree().create_timer(0.2).timeout
	show_circular_burst(position, 6, Color.GOLD)

## Efecto de fallo con animación compleja
func show_failure_effect(position: Vector2):
	"""
	Muestra un efecto complejo para indicar fallo
	
	Args:
		position: Posición donde mostrar el efecto
	"""
	show_glow_burst(position, Color.RED)
	show_negative_feedback(position, 8)
	await get_tree().create_timer(0.2).timeout
	show_circular_burst(position, 6, Color.RED)

## Crea un destello individual animado
func _spawn_sparkle(position: Vector2, color: Color, sparkle_scale: float = 1.0):
	"""
	Crea un destello individual con animación
	
	Args:
		position: Posición del destello
		color: Color del destello
		sparkle_scale: Escala inicial del destello
	"""
	var sparkle = ColorRect.new()
	sparkle.color = color
	sparkle.size = Vector2(8, 8) * sparkle_scale
	sparkle.position = position - sparkle.size / 2
	sparkle.modulate.a = 0.9
	add_child(sparkle)
	
	# Dirección aleatoria para el movimiento
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var velocity = direction * randf_range(50, 150)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	
	# Movimiento con desaceleración
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sparkle, "position", sparkle.position + velocity * SPARKLE_DURATION, SPARKLE_DURATION)
	
	# Desvanecimiento
	tween.tween_property(sparkle, "modulate:a", 0.0, SPARKLE_DURATION)
	
	# Escala
	tween.tween_property(sparkle, "scale", Vector2(0.5, 0.5), SPARKLE_DURATION)
	
	await tween.finished
	sparkle.queue_free()

func _spawn_sign_effect(position: Vector2, sign: String, color: Color, sign_scale: float = 1.0):
	var label = Label.new()
	label.text = sign
	var label_size = Vector2(40, 40) * sign_scale
	label.custom_minimum_size = label_size
	label.modulate = color
	label.add_theme_font_size_override("font_size", int(36 * sign_scale))
	add_child(label)
	label.position = position - label_size / 2

	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var velocity = direction * randf_range(50, 150)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position", label.position + velocity * SPARKLE_DURATION, SPARKLE_DURATION)
	tween.tween_property(label, "modulate:a", 0.0, SPARKLE_DURATION)
	tween.tween_property(label, "scale", Vector2(0.5, 0.5), SPARKLE_DURATION)
	
	await tween.finished
	label.queue_free()

func _spawn_asset_sparkle(position: Vector2, scene: PackedScene, base_scale: float = 1.0, tint: Color = Color.WHITE):
	var effect = scene.instantiate()
	if effect is Node2D:
		effect.position = position
		var sprite = effect.get_node_or_null("Sprite2D")
		if sprite:
			sprite.modulate = tint
			sprite.scale = Vector2(base_scale, base_scale)
		add_child(effect)
	
		var tween = create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		var target = position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		tween.tween_property(effect, "position", target, SPARKLE_DURATION)
		tween.tween_property(sprite, "modulate:a", 0.0, SPARKLE_DURATION)
		await tween.finished
		effect.queue_free()
	else:
		_spawn_sparkle(position, tint, base_scale)
