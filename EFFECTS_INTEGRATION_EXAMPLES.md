## Ejemplo de Integración: Mostrar Efectos al Tomar Decisiones

Este archivo muestra ejemplos prácticos de cómo integrar la `EffectsLayer` en tu código actual.

### Opción 1: En el UIController (Recomendado)

Cuando el jugador completa una tarea o toma una decisión, puedes mostrar un efecto:

```gdscript
# En UIController.gd, cuando se completa una tarea exitosamente

func _on_task_completed_successfully(task_name: String):
	var game_manager = get_tree().root.find_child("GameManager", true, false)
	var effects_layer = game_manager.effects_layer
	
	# Mostrar efecto de éxito en el centro de la pantalla
	var screen_center = get_viewport().get_visible_rect().get_center()
	await effects_layer.show_success_effect(screen_center)
	
	# Luego mostrar el timeline del evento
	Dialogic.start(event_timeline_id)
```

### Opción 2: En el GameManager (Para Eventos Globales)

Cuando ocurre un evento importante del juego:

```gdscript
# En GameManager.gd, cuando se activa un evento

func _activate_event(event_id: String):
	var positive_event = true  # Determinar si el evento es positivo o negativo
	var screen_center = get_viewport().get_visible_rect().get_center()
	
	if positive_event:
		await effects_layer.show_success_effect(screen_center)
	else:
		await effects_layer.show_failure_effect(screen_center)
	
	Dialogic.start(event_id)
```

### Opción 3: Efectos en Posiciones Específicas

Si quieres mostrar el efecto en la posición del botón o elemento clicado:

```gdscript
# Modificar tus conexiones de señales de botones

func _on_character_button_pressed(character_node: Node):
	var button_position = character_node.get_global_rect().get_center()
	effects_layer.show_positive_feedback(button_position, 6)
	
	# Continuar con la lógica
	process_character_selection(character_node)
```

### Opción 4: Retroalimentación Inmediata de Puntos

Cuando se asignan puntos por una decisión:

```gdscript
# En tu sistema de puntaje

func add_points(category: String, amount: int, source_position: Vector2):
	var effects_layer = get_tree().root.find_child("EffectsLayer", true, false)
	
	# Mostrar intensidad basada en cantidad de puntos
	var intensity = min(amount / 5, 12)
	effects_layer.show_positive_feedback(source_position, intensity)
	
	# Actualizar puntaje
	project.add_score(category, amount)

func subtract_points(category: String, amount: int, source_position: Vector2):
	var effects_layer = get_tree().root.find_child("EffectsLayer", true, false)
	
	var intensity = min(amount / 5, 12)
	effects_layer.show_negative_feedback(source_position, intensity)
	
	project.subtract_score(category, amount)
```

### Opción 5: Conexión con Dialogic Timelines

Para mostrar efectos cuando un timeline comienza:

```gdscript
# En GameManager.gd o donde configuraste la conexión de Dialogic

func _ready():
	if not Dialogic.timeline_started.is_connected(_on_dialogic_timeline_started):
		Dialogic.timeline_started.connect(_on_dialogic_timeline_started)

func _on_dialogic_timeline_started(timeline_name: String):
	var effects_layer = get_tree().root.find_child("EffectsLayer", true, false)
	
	# Mostrar efecto neutral cuando inicia un timeline
	var screen_center = get_viewport().get_visible_rect().get_center()
	effects_layer.show_quick_flash(screen_center, Color.WHITE, 0.1)
```

### Ejemplo Completo: Sistema de Retroalimentación Integrado

Este es un patrón más completo que podrías implementar:

```gdscript
# Crear un nuevo script: res://scripts/FeedbackSystem.gd

extends Node
class_name FeedbackSystem

var effects_layer: CanvasLayer

func _ready():
	effects_layer = get_tree().root.find_child("EffectsLayer", true, false)

## Mostrar retroalimentación de decisión
func show_decision_feedback(is_good: bool, position: Vector2 = Vector2.ZERO):
	if position == Vector2.ZERO:
		position = get_viewport().get_visible_rect().get_center()
	
	if is_good:
		await effects_layer.show_success_effect(position)
	else:
		await effects_layer.show_failure_effect(position)

## Mostrar retroalimentación de puntos
func show_points_feedback(points: int, position: Vector2 = Vector2.ZERO):
	if position == Vector2.ZERO:
		position = get_viewport().get_visible_rect().get_center()
	
	if points > 0:
		var intensity = min(points / 5, 15)
		effects_layer.show_positive_feedback(position, intensity)
	elif points < 0:
		var intensity = min(abs(points) / 5, 15)
		effects_layer.show_negative_feedback(position, intensity)
	else:
		effects_layer.show_neutral_feedback(position, 3)

## Mostrar notificación visual
func show_notification(notification_type: String, position: Vector2 = Vector2.ZERO):
	if position == Vector2.ZERO:
		position = get_viewport().get_visible_rect().get_center()
	
	match notification_type:
		"task_complete":
			effects_layer.show_circular_burst(position, 8, Color.GOLD)
		"level_up":
			await effects_layer.show_success_effect(position)
		"alert":
			effects_layer.show_negative_feedback(position, 5)
		"info":
			effects_layer.show_neutral_feedback(position, 4)
```

Luego en tu código, simplemente llamas:

```gdscript
var feedback = get_tree().root.find_child("FeedbackSystem", true, false)

# Cuando el jugador toma una buena decisión
await feedback.show_decision_feedback(true)

# Cuando gana puntos
feedback.show_points_feedback(15, button_position)

# Para notificaciones
feedback.show_notification("task_complete", center_position)
```

## Dónde Integrar

Basado en la estructura actual del proyecto, recomiendo:

1. **Para eventos de Dialogic**: En `EventSystem.gd` o `GameManager.gd`
2. **Para decisiones de UI**: En `UIController.gd`
3. **Para cambios de puntaje**: En `ProjectSystem.gd` o donde manejes el puntaje
4. **Para notificaciones**: Crear `FeedbackSystem.gd` como nodo singleton

## Prueba Rápida

Para probar la EffectsLayer sin cambios complejos, ejecuta esto en la consola del Godot Editor:

```gdscript
var effects = get_tree().root.find_child("EffectsLayer", true, false)
effects.show_success_effect(get_viewport().get_visible_rect().get_center())
```
