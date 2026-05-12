# Guía de Uso: EffectsLayer (Capa de Efectos Visuales)

## Descripción General
`EffectsLayer` es una capa de efectos visuales que se superpone sobre los timelines de Dialogic y otros elementos de la UI. Proporciona funciones para mostrar destellos, brillos y otras animaciones visuales como retroalimentación inmediata.

## Ubicación
- **Escena**: `res://escenas/effects_layer.tscn`
- **Script**: `res://scripts/EffectsLayer.gd`
- **Integración**: Se carga automáticamente en `main_game.tscn`

## Acceso desde otros Scripts
Para acceder a la `EffectsLayer` desde cualquier script, puedes hacerlo a través de `GameManager`:

```gdscript
var game_manager = get_tree().root.find_child("GameManager", true, false)
var effects_layer = game_manager.effects_layer

# O directamente
var effects_layer = get_tree().root.find_child("EffectsLayer", true, false)
```

## Funciones Disponibles

### 1. `show_positive_feedback(position: Vector2, intensity: int = 5)`
Muestra destellos dorados para retroalimentación positiva (decisión buena, puntos ganados).

**Ejemplo:**
```gdscript
effects_layer.show_positive_feedback(get_global_mouse_position(), 8)
```

### 2. `show_negative_feedback(position: Vector2, intensity: int = 5)`
Muestra destellos rojos para retroalimentación negativa (decisión mala, puntos perdidos).

**Ejemplo:**
```gdscript
effects_layer.show_negative_feedback(Vector2(640, 360), 5)
```

### 3. `show_neutral_feedback(position: Vector2, intensity: int = 5)`
Muestra destellos azules para retroalimentación neutral o informativa.

**Ejemplo:**
```gdscript
effects_layer.show_neutral_feedback(button_position)
```

### 4. `show_glow_burst(position: Vector2, color: Color = Color.YELLOW)`
Muestra un efecto de resplandor que se expande desde el centro de la posición.

**Ejemplo:**
```gdscript
effects_layer.show_glow_burst(center_position, Color.GOLD)
await effects_layer.show_glow_burst(center_position)  # Esperar a que termine
```

### 5. `show_quick_flash(position: Vector2, color: Color = Color.WHITE, duration: float = 0.3)`
Muestra un destello rápido que desaparece rápidamente.

**Ejemplo:**
```gdscript
effects_layer.show_quick_flash(target_pos, Color.WHITE, 0.2)
```

### 6. `show_circular_burst(center: Vector2, effect_count: int = 8, color: Color = Color.GOLD)`
Muestra múltiples destellos distribuidos en un patrón circular.

**Ejemplo:**
```gdscript
effects_layer.show_circular_burst(Vector2(640, 360), 12, Color.GOLD)
```

### 7. `show_success_effect(position: Vector2)` (async)
Muestra una animación compleja para indicar éxito (resplandor + destellos + ráfaga circular).

**Ejemplo:**
```gdscript
await effects_layer.show_success_effect(Vector2(640, 360))
print("Efecto de éxito completado")
```

### 8. `show_failure_effect(position: Vector2)` (async)
Muestra una animación compleja para indicar fallo.

**Ejemplo:**
```gdscript
await effects_layer.show_failure_effect(error_position)
```

## Casos de Uso Recomendados

### Cuando un Evento Positivo Ocurre
```gdscript
func _on_positive_decision_made(position: Vector2):
	await effects_layer.show_success_effect(position)
	# El evento aparecerá sobre el efecto
	Dialogic.start(positive_event_timeline)
```

### Cuando se Gana Puntos
```gdscript
func _on_points_gained(amount: int, position: Vector2):
	effects_layer.show_positive_feedback(position, min(amount / 2, 10))
	update_score_display()
```

### Cuando se Pierden Puntos
```gdscript
func _on_points_lost(position: Vector2):
	effects_layer.show_negative_feedback(position)
	play_negative_sound()
```

### Notificación General
```gdscript
func _on_notification(message: String, position: Vector2):
	effects_layer.show_neutral_feedback(position, 3)
	show_notification_label(message)
```

## Integración con EventSystem y GameManager

Sugerencia para integración más profunda:

```gdscript
# En GameManager.gd, después de activar un evento:
func _activate_event(event_data: Dictionary):
	# Mostrar efecto antes del timeline
	if event_data.get("is_positive", false):
		await effects_layer.show_success_effect(get_viewport().get_visible_rect().get_center())
	else:
		await effects_layer.show_neutral_feedback(get_viewport().get_visible_rect().get_center())
	
	# Luego mostrar el timeline
	Dialogic.start(event_data["id"])
```

## Personalización

Todos los colores se pueden personalizar pasando valores `Color`. Ejemplos:
- `Color.GOLD` - Dorado
- `Color.RED` - Rojo
- `Color.CYAN` - Cyan
- `Color(1.0, 0.5, 0.0)` - Naranja personalizado

Las duraciones también se pueden ajustar modificando las constantes en `EffectsLayer.gd`:
- `GLOW_BURST_DURATION = 1.5` - Duración del resplandor
- `SPARKLE_DURATION = 2.0` - Duración de los destellos

## Notas Técnicas

- Todos los efectos se renderizan con **fondo transparente** usando `CanvasLayer` con `layer = 10`
- Los efectos son **completamente no-bloqueantes**: se ejecutan sobre otros elementos sin interferir
- Las funciones que terminan en `(async)` pueden ser esperadas con `await`
- Todos los efectos se limpian automáticamente de memoria después de completarse

## Ejemplo Completo de Integración

```gdscript
# En tu script de decisiones o eventos
extends Node

@onready var effects_layer = get_tree().root.find_child("EffectsLayer", true, false)

func on_decision_made(decision: String, position: Vector2):
	match decision:
		"good_decision":
			await effects_layer.show_success_effect(position)
			Dialogic.start("res://dialogic/timelines/positive_event.dtl")
		
		"bad_decision":
			await effects_layer.show_failure_effect(position)
			Dialogic.start("res://dialogic/timelines/negative_event.dtl")
		
		"neutral_decision":
			effects_layer.show_neutral_feedback(position)
			Dialogic.start("res://dialogic/timelines/neutral_event.dtl")
```
