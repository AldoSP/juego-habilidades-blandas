## Script de Prueba: EffectsLayer

Este script es opcional y puede usarse para probar la EffectsLayer durante el desarrollo.

### Cómo usar:

1. Crea un nodo en tu escena (por ejemplo, un Node vacío llamado "EffectsLayerTest")
2. Adjunta este script a ese nodo
3. Ejecuta el juego y presiona las teclas indicadas para probar cada efecto

### Código de Prueba:

```gdscript
# res://scripts/EffectsLayerTest.gd
extends Node

var effects_layer: CanvasLayer

func _ready():
	effects_layer = get_tree().root.find_child("EffectsLayer", true, false)
	if effects_layer == null:
		print("ERROR: EffectsLayer no encontrada")
		return
	print("✓ EffectsLayer cargada correctamente")

func _input(event):
	if not event is InputEventKey or not event.pressed:
		return
	
	var center = get_viewport().get_visible_rect().get_center()
	var mouse_pos = get_global_mouse_position()
	
	match event.keycode:
		KEY_1:  # Retroalimentación positiva
			effects_layer.show_positive_feedback(mouse_pos, 6)
			print("✓ Efecto positivo (dorado) en posición del mouse")
		
		KEY_2:  # Retroalimentación negativa
			effects_layer.show_negative_feedback(mouse_pos, 6)
			print("✓ Efecto negativo (rojo) en posición del mouse")
		
		KEY_3:  # Retroalimentación neutral
			effects_layer.show_neutral_feedback(mouse_pos, 6)
			print("✓ Efecto neutral (azul) en posición del mouse")
		
		KEY_4:  # Resplandor
			effects_layer.show_glow_burst(center, Color.GOLD)
			print("✓ Resplandor dorado en centro")
		
		KEY_5:  # Destello rápido
			effects_layer.show_quick_flash(mouse_pos, Color.WHITE, 0.2)
			print("✓ Destello blanco rápido")
		
		KEY_6:  # Ráfaga circular
			effects_layer.show_circular_burst(center, 12, Color.GOLD)
			print("✓ Ráfaga circular de 12 destellos")
		
		KEY_7:  # Efecto de éxito (async)
			print("► Iniciando efecto de éxito...")
			await effects_layer.show_success_effect(center)
			print("✓ Efecto de éxito completado")
		
		KEY_8:  # Efecto de fallo (async)
			print("► Iniciando efecto de fallo...")
			await effects_layer.show_failure_effect(center)
			print("✓ Efecto de fallo completado")
		
		KEY_0:  # Información
			print_help()

func print_help():
	print("\n" + "="*50)
	print("CONTROLES DE PRUEBA - EffectsLayer")
	print("="*50)
	print("1 - Retroalimentación Positiva (Dorado)")
	print("2 - Retroalimentación Negativa (Rojo)")
	print("3 - Retroalimentación Neutral (Azul)")
	print("4 - Resplandor Expansivo")
	print("5 - Destello Rápido")
	print("6 - Ráfaga Circular")
	print("7 - Efecto de Éxito Completo")
	print("8 - Efecto de Fallo Completo")
	print("0 - Mostrar esta ayuda")
	print("="*50 + "\n")
```

### Instrucciones:

1. **Crear el nodo de prueba** (Opcional - solo para desarrollo):
   ```
   MainGame
   └── EffectsLayerTest (Node) [adjuntar el script de prueba]
   ```

2. **Ejecutar el juego** y presiona las teclas 1-8 para probar

3. **Observar en la consola** los mensajes de confirmación

4. **Resultados esperados**:
   - Las teclas 1-6 muestran efectos inmediatos
   - Las teclas 7-8 muestran efectos más complejos (puedes observar en la consola cuando terminan)
   - La tecla 0 muestra los controles disponibles

### Información Adicional:

- Los efectos aparecen en la **posición del mouse** (excepto los que usan el centro)
- Los efectos son **no-bloqueantes** (excepto los async que puedes esperar con `await`)
- Todos los efectos usan **fondo transparente**
- Los efectos se **limpian automáticamente** después de terminar

### Desactivar la prueba:

Simplemente elimina o desactiva el nodo `EffectsLayerTest` cuando no lo necesites.
