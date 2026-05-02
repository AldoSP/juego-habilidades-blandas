# Documentación del Sistema de Juego - Habilidades Blandas

## Descripción General

Se ha implementado un sistema completo de flujo de juego que conecta:
1. **Asignación de Tareas** (UI)
2. **Cálculo de Tareas** (TaskSystem)
3. **Eventos Aleatorios** (EventSystem)
4. **Acumulación de Resultados** (ProjectSystem)

## Arquitectura

### Escena Principal: `main_game.tscn`

La escena contiene:
- **GameManager**: Orquesta todo el flujo del juego
- **TeamSystem**: Gestiona los personajes y sus atributos
- **TaskSystem**: Calcula los resultados de las tareas
- **ProjectSystem**: Acumula los puntos del proyecto
- **UIController**: Gestiona la interfaz y las interacciones del jugador

### Flujo del Juego

```
┌─────────────────────────────────────────────────────────┐
│ Inicio del Día                                          │
│ - Mostrar panel de asignación de tareas               │
└──────────────────┬──────────────────────────────────────┘
				   │
				   ▼
┌─────────────────────────────────────────────────────────┐
│ Asignar Tareas                                          │
│ - Jugador selecciona personaje                         │
│ - Jugador selecciona tarea (Programming/Design/Testing)│
│ - Jugador confirma asignaciones                        │
└──────────────────┬──────────────────────────────────────┘
				   │
				   ▼
┌─────────────────────────────────────────────────────────┐
│ Procesar Eventos Aleatorios                             │
│ - Para cada personaje: 50% de probabilidad de evento   │
│ - Mostrar evento y opciones (Sí/No)                    │
│ - Aplicar modificadores según la decisión             │
└──────────────────┬──────────────────────────────────────┘
				   │
				   ▼
┌─────────────────────────────────────────────────────────┐
│ Calcular Tareas                                         │
│ - TaskSystem calcula puntuación de cada personaje      │
│ - Se aplican modificadores de eventos                  │
│ - Se reduce energía de cada personaje                  │
└──────────────────┬──────────────────────────────────────┘
				   │
				   ▼
┌─────────────────────────────────────────────────────────┐
│ Mostrar Resultados                                      │
│ - Programming: XXX                                      │
│ - Design: XXX                                           │
│ - Testing: XXX                                          │
└──────────────────┬──────────────────────────────────────┘
				   │
				   ▼
┌─────────────────────────────────────────────────────────┐
│ Fin del Día / Inicio del Siguiente                     │
│ - Si día < max_days: volver al inicio                  │
│ - Si día == max_days: finalizar juego                  │
└─────────────────────────────────────────────────────────┘
```

## Scripts Principales

### GameManager.gd
- **Responsabilidad**: Orquestar el flujo del juego
- **Métodos clave**:
  - `start_day()`: Inicia un nuevo día
  - `_on_tasks_assigned()`: Se ejecuta cuando el jugador confirma tareas
  - `process_events()`: Genera y procesa eventos aleatorios
  - `show_next_event()`: Muestra el siguiente evento
  - `calculate_tasks()`: Calcula los resultados de las tareas
  - `end_day()`: Finaliza el día y prepara el siguiente

### UIController.gd
- **Responsabilidad**: Gestionar la interfaz de usuario
- **Métodos clave**:
  - `assign_task(task_name)`: Asigna una tarea al personaje seleccionado
  - `show_event_decision()`: Muestra un evento en la UI
  - `show_results()`: Muestra los resultados del día
  - `_on_confirm_button_pressed()`: Maneja la confirmación de asignaciones
  - `_on_event_yes_pressed()` / `_on_event_no_pressed()`: Maneja decisiones de eventos
  - `_on_continue_button_pressed()`: Continúa al siguiente día

### TaskSystem.gd
- **Responsabilidad**: Calcular los resultados de las tareas
- **Métodos clave**:
  - `calculate_task(character, task_type)`: Calcula la puntuación para una tarea
  - `resolve_all(characters)`: Resuelve todas las tareas del día

### EventSystem.gd
- **Responsabilidad**: Generar y resolver eventos aleatorios
- **Métodos clave**:
  - `maybe_trigger_random_event(character, task_type)`: Genera un evento aleatorio
  - `resolve_event(character, event, accepted)`: Resuelve un evento y aplica modificadores

### ProjectSystem.gd
- **Responsabilidad**: Acumular los puntos del proyecto
- **Métodos clave**:
  - `apply_results(results)`: Suma los puntos a los totales del proyecto

### TeamSystem.gd
- **Responsabilidad**: Gestionar los personajes
- **Atributos de Character**:
  - `name`: Nombre del personaje
  - `strength`: Fortaleza (tarea en la que es mejor)
  - `weakness`: Debilidad (tarea en la que es peor)
  - `energy`: Energía (comienza en 100, se reduce con cada tarea)
  - `assigned_task`: Tarea asignada para el día
  - `event_modifier`: Modificador de puntuación por eventos

## Cálculo de Tareas

La puntuación se calcula así:

```
base = 5
multiplier = 1.0

Si task_type == strength:
	multiplier = 1.5
Si task_type == weakness:
	multiplier = 0.5

Si energy < 30:
	multiplier *= 0.5

score = int(base * multiplier) + event_modifier
si score < 0:
	score = 0
```

## Eventos Disponibles

1. **client_change** (Programming): Cliente pide cambios urgentes
   - Sí: +4 puntos
   - No: -2 puntos

2. **creative_block** (Design): Dificultad creativa
   - Sí: +3 puntos
   - No: -1 punto

3. **bug_discovery** (Testing): Se descubre un bug importante
   - Sí: +2 puntos
   - No: -3 puntos

4. **any_help** (Any): Oportunidad extra para cualquier tarea
   - Sí: +2 puntos
   - No: -1 punto

## Cómo Ejecutar

1. Abre Godot
2. Abre el proyecto
3. Presiona F5 para ejecutar
4. La escena `main_game.tscn` se ejecutará automáticamente

## Personalización

### Para cambiar el número de días:
En `GameManager.gd`, línea 12:
```gdscript
var max_days = 3  # Cambia este número
```

### Para agregar más eventos:
En `EventSystem.gd`, en el array `events`, agrega un nuevo diccionario:
```gdscript
{
	"id": "event_id",
	"description": "Descripción del evento",
	"task": "programming",  # o "design", "testing", "any"
	"yes_delta": 3,
	"no_delta": -1,
	"yes_text": "Aceptas...",
	"no_text": "Rechazas..."
}
```

### Para modificar personajes:
En `TeamSystem.gd`, línea 14:
```gdscript
func _ready():
	characters.append(Character.new("Nombre", "fortaleza", "debilidad"))
```

## Señales Disponibles

Desde `UIController`:
- `tasks_assigned`: Se emite cuando el jugador confirma las tareas
- `event_decision_made(character_index, decision)`: Se emite cuando se toma una decisión sobre un evento

Desde `EventSystem`:
- `event_requested(character, event)`: Se emite cuando se genera un evento
- `event_resolved(character, event, accepted, score_delta)`: Se emite cuando se resuelve un evento

## Notas Importantes

- La UI es **rudimentaria** (solo botones y etiquetas) como se solicitó
- Los botones emiten señales correctamente
- Todo está conectado y funcional
- Los eventos se generan con 50% de probabilidad
- La energía se reduce en 10 puntos por tarea
