extends Control

# Señales del flujo principal
signal tasks_assigned
signal event_decision_made(character_index, decision)

var team_system
var task_system
var event_system
var project_system
var game_manager

var selected_character = null
var characters = {}
var character_names = ["Ana", "Mateo", "Sofia"]
var assignments = {}  # task_name -> character_name

# Referencia a los paneles
var assignment_panel
var event_panel
var results_panel
var game_over_panel
var characters_container
var tasks_container
var floating_layer  # Contenedor para botones animados

# Estado del evento actual
var current_event_data = null
var current_event_index = 0

# Almacenar botones asignados para restaurarlos
var assigned_buttons = {}  # task_name -> {button, original_pos}
var animated_buttons = []  # Lista de botones animados activos

func _ready():
	# Inicializamos personajes
	for name in character_names:
		characters[name] = {"task": null}
	
	# Inicializar asignaciones por tarea
	var tasks = ["programming", "design", "testing", "rest"]
	for task in tasks:
		assignments[task] = null
	
	# Obtener referencias a los paneles
	assignment_panel = $AssignmentPanel
	event_panel = $EventPanel
	results_panel = $ResultsPanel
	game_over_panel = $GameOverPanel
	characters_container = $AssignmentPanel/VBoxContainer/CharactersContainer
	tasks_container = $AssignmentPanel/VBoxContainer/TasksContainer
	
	# Crear un contenedor flotante para los botones asignados
	floating_layer = Control.new()
	floating_layer.name = "FloatingLayer"
	floating_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	floating_layer.anchors_preset = Control.PRESET_FULL_RECT
	floating_layer.anchor_right = 1.0
	floating_layer.anchor_bottom = 1.0
	add_child(floating_layer)

func setup(team, task_sys, event_sys, project_sys, gm):
	team_system = team
	task_system = task_sys
	event_system = event_sys
	project_system = project_sys
	game_manager = gm
	
	# Esperar un frame para asegurar que _ready() ha completado
	await get_tree().process_frame
	
	# Conectar botones que existen en la escena
	var confirm_button = assignment_panel.get_node_or_null("VBoxContainer/ControlsContainer/ConfirmButton")
	if confirm_button:
		confirm_button.pressed.connect(_on_confirm_button_pressed)
	
	var reset_button = assignment_panel.get_node_or_null("VBoxContainer/ControlsContainer/ResetButton")
	if reset_button:
		reset_button.pressed.connect(_on_reset_button_pressed)
	
	var yes_button = event_panel.get_node_or_null("YesButton")
	if yes_button:
		yes_button.pressed.connect(_on_event_yes_pressed)
	
	var no_button = event_panel.get_node_or_null("NoButton")
	if no_button:
		no_button.pressed.connect(_on_event_no_pressed)
	
	var continue_button = results_panel.get_node_or_null("ContinueButton")
	if continue_button:
		continue_button.pressed.connect(_on_continue_button_pressed)
	
	# Crear botones visuales para personajes
	create_character_buttons()
	create_task_buttons()

func create_character_buttons():
	"""Crea botones visuales para cada personaje"""
	for char_name in character_names:
		var button = Button.new()
		button.text = char_name
		button.custom_minimum_size = Vector2(100, 80)
		button.modulate = Color.from_string("6ba3ffff", Color.WHITE)  # Azul
		button.pressed.connect(_on_character_button_pressed.bindv([char_name]))
		characters_container.add_child(button)

func create_task_buttons():
	"""Crea botones interactivos para cada tarea"""
	var tasks = ["programming", "design", "testing", "rest"]
	for task in tasks:
		var area = tasks_container.find_child(task.capitalize() + "_Area", true, false)
		if area:
			var button = Button.new()
			button.text = "→ Asignar"
			button.custom_minimum_size = Vector2(160, 40)
			var task_vbox = area.get_child(0)
			if task_vbox:
				task_vbox.add_child(button)
				button.pressed.connect(_on_task_button_pressed.bindv([task]))

func _on_character_button_pressed(char_name: String):
	"""Se llama cuando se hace click en un personaje"""
	if selected_character == char_name:
		# Deseleccionar
		selected_character = null
		_update_character_button_appearance()
		print("Deseleccionado: ", char_name)
	else:
		# Seleccionar nuevo personaje
		selected_character = char_name
		_update_character_button_appearance()
		print("Seleccionado: ", char_name)

func _on_task_button_pressed(task_name: String):
	"""Se llama cuando se hace click en una tarea"""
	if selected_character == null:
		print("Selecciona un personaje primero")
		return
	
	assign_character_to_task(selected_character, task_name)

func assign_character_to_task(char_name: String, task_name: String):
	"""Asigna un personaje a una tarea con animación que se mantiene"""
	print("Asignando ", char_name, " a ", task_name)
	
	# Si el personaje ya estaba asignado a otra tarea, desasignarlo primero
	var old_task = characters[char_name]["task"]
	if old_task != null and old_task != task_name:
		# Desasignar de la tarea anterior
		if old_task in assigned_buttons:
			assigned_buttons[old_task]["button"].queue_free()
			assigned_buttons.erase(old_task)
		
		# Limpiar etiqueta de la tarea anterior
		var old_area = tasks_container.find_child(old_task.capitalize() + "_Area", true, false)
		if old_area:
			var old_assigned_label = old_area.get_node("VBoxContainer/AssignedCharacter")
			if old_assigned_label:
				old_assigned_label.text = "(Sin asignar)"
				old_assigned_label.modulate = Color.WHITE
		
		assignments[old_task] = null
	
	# Si ya hay otro personaje asignado en esta tarea, desasignarlo
	if task_name in assignments and assignments[task_name] != null:
		var previous_char = assignments[task_name]
		characters[previous_char]["task"] = null
		
		if task_name in assigned_buttons:
			assigned_buttons[task_name]["button"].queue_free()
			assigned_buttons.erase(task_name)
	
	# Actualizar el registro de asignaciones
	characters[char_name]["task"] = task_name
	assignments[task_name] = char_name
	
	# Obtener referencias
	var char_button = characters_container.get_child(character_names.find(char_name))
	var area = tasks_container.find_child(task_name.capitalize() + "_Area", true, false)
	
	if char_button and area:
		# Obtener posiciones globales
		var start_pos = char_button.global_position
		
		# Calcular el centro del VBoxContainer dentro del área (posición más precisa)
		var vbox = area.get_node("VBoxContainer")
		var area_rect = area.get_global_rect()
		var vbox_rect = vbox.get_global_rect() if vbox else area_rect
		var end_pos = vbox_rect.get_center()
		
		# Crear un botón permanente que se quedará en la tarea
		var assigned_button = Button.new()
		assigned_button.text = char_name
		assigned_button.custom_minimum_size = Vector2(100, 80)
		assigned_button.modulate = Color.from_string("6ba3ffff", Color.WHITE)
		assigned_button.global_position = start_pos
		assigned_button.mouse_filter = Control.MOUSE_FILTER_IGNORE  # No interfiera con clics
		floating_layer.add_child(assigned_button)
		
		# Guardar referencia para restaurarlo después
		assigned_buttons[task_name] = {
			"button": assigned_button,
			"original_pos": start_pos,
			"final_pos": end_pos
		}
		
		# Ocultar el botón original
		char_button.visible = false
		
		# Animar el movimiento
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(assigned_button, "global_position", end_pos, 0.6)
		
		# Esperar a que termine la animación
		await tween.finished
		
		# Actualizar etiqueta de la tarea
		var assigned_label = area.get_node("VBoxContainer/AssignedCharacter")
		if assigned_label:
			assigned_label.text = char_name
			assigned_label.modulate = Color.from_string("a8ff69ff", Color.WHITE)  # Verde
		
		# Actualizar apariencia del botón original
		char_button.modulate = Color.from_string("a8ff69ff", Color.WHITE)  # Verde
		char_button.text = char_name + " ✓"
		# NO mostrar el botón original si está asignado
		# char_button.visible = true
	
	selected_character = null
	_update_character_button_appearance()

func _update_character_button_appearance():
	"""Actualiza el aspecto de los botones de personaje según selección"""
	for i in range(character_names.size()):
		var char_name = character_names[i]
		var button = characters_container.get_child(i)
		
		if characters[char_name]["task"] != null:
			# Personaje asignado: ocultar botón
			button.visible = false
		elif char_name == selected_character:
			# Personaje seleccionado: mostrar en blanco
			button.visible = true
			button.modulate = Color.WHITE
		else:
			# Personaje disponible: mostrar en azul
			button.visible = true
			button.modulate = Color.from_string("6ba3ffff", Color.WHITE)  # Azul

func _on_confirm_button_pressed():
	"""Se llama cuando se confirman las asignaciones"""
	print("Asignaciones finales:")
	print(characters)
	
	# Aplicar asignaciones a los personajes del team_system
	if team_system:
		for i in range(team_system.characters.size()):
			var character = team_system.characters[i]
			if character.name in characters:
				character.assigned_task = characters[character.name]["task"]
				print("Aplicado: ", character.name, " -> ", character.assigned_task)
	
	# Ocultar panel de asignación
	_show_assignment_panel(false)
	
	emit_signal("tasks_assigned")

func show_event_decision(character, event, event_index):
	"""Muestra una UI con la decisión del evento"""
	current_event_data = {
		"character": character,
		"event": event,
		"index": event_index
	}
	current_event_index = event_index
	
	print("Mostrando evento para ", character.name, ": ", event.description)
	
	# Actualizar UI del evento
	var event_title = event_panel.get_node("EventTitle")
	var event_description = event_panel.get_node("EventDescription")
	var yes_button = event_panel.get_node("YesButton")
	var no_button = event_panel.get_node("NoButton")
	
	event_title.text = character.name + " - " + event.id
	event_description.text = event.description
	yes_button.text = event.yes_text + " (+%d)" % event.yes_delta
	no_button.text = event.no_text + " (%d)" % event.no_delta
	
	# Mostrar panel de evento
	_show_event_panel(true)

func _on_event_yes_pressed():
	if current_event_data:
		emit_signal("event_decision_made", current_event_index, true)

func _on_event_no_pressed():
	if current_event_data:
		emit_signal("event_decision_made", current_event_index, false)

func show_results(results):
	"""Muestra los resultados del día"""
	print("Mostrando resultados del día")
	
	# Actualizar etiquetas de resultados
	var prog_label = results_panel.get_node("ProgrammingResult")
	var design_label = results_panel.get_node("DesignResult")
	var testing_label = results_panel.get_node("TestingResult")
	
	prog_label.text = "Programming: %d" % results["programming"]
	design_label.text = "Design: %d" % results["design"]
	testing_label.text = "Testing: %d" % results["testing"]
	
	# Mostrar panel de resultados
	_show_results_panel(true)

func reset_assignments():
	"""Limpia todas las asignaciones y restaura los botones a su posición original"""
	print("Reasignando personajes...")
	
	# Restaurar todos los botones asignados a su posición original
	for task_name in assigned_buttons.keys():
		var button_data = assigned_buttons[task_name]
		var button = button_data["button"]
		var original_pos = button_data["original_pos"]
		
		# Animar de vuelta a la posición original
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "global_position", original_pos, 0.6)
		await tween.finished
		button.queue_free()
	
	# Limpiar asignaciones
	assigned_buttons.clear()
	animated_buttons.clear()
	
	for name in character_names:
		characters[name]["task"] = null
	
	# Reinicializar assignments
	var tasks = ["programming", "design", "testing", "rest"]
	for task in tasks:
		assignments[task] = null
	
	# Limpiar etiquetas de tareas
	for task in tasks:
		var area = tasks_container.find_child(task.capitalize() + "_Area", true, false)
		if area:
			var assigned_label = area.get_node("VBoxContainer/AssignedCharacter")
			if assigned_label:
				assigned_label.text = "(Sin asignar)"
				assigned_label.modulate = Color.WHITE
	
	# Restaurar apariencia de botones
	for i in range(character_names.size()):
		var button = characters_container.get_child(i)
		button.modulate = Color.from_string("6ba3ffff", Color.WHITE)
		button.text = character_names[i]
		button.visible = true  # Restaurar visibilidad
	
	selected_character = null

func _on_reset_button_pressed():
	"""Se llama cuando se presiona el botón de limpiar selección"""
	print("Botón de reasignación presionado")
	await reset_assignments()
	_update_character_button_appearance()

func _on_continue_button_pressed():
	print("Continuando a próximo día")
	_show_results_panel(false)
	_show_assignment_panel(true)
	
	# Usar el método de limpieza
	await reset_assignments()
	
	# Reiniciar el siguiente día
	if game_manager:
		game_manager.start_day()

func show_game_over(final_stats):
	"""Muestra la pantalla de fin de juego"""
	print("Mostrando pantalla de fin de juego")
	
	_show_results_panel(false)
	_show_event_panel(false)
	_show_assignment_panel(false)
	
	# Actualizar etiquetas de fin de juego
	var title = game_over_panel.get_node("GameOverTitle")
	var prog_label = game_over_panel.get_node("ProgrammingFinal")
	var design_label = game_over_panel.get_node("DesignFinal")
	var testing_label = game_over_panel.get_node("TestingFinal")
	
	title.text = "¡FIN DEL JUEGO!"
	prog_label.text = "Programming: %d" % final_stats["programming"]
	design_label.text = "Design: %d" % final_stats["design"]
	testing_label.text = "Testing: %d" % final_stats["testing"]
	
	_show_game_over_panel(true)

func _on_restart_button_pressed():
	print("Reiniciando juego")
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	print("Saliendo del juego")
	get_tree().quit()

# Funciones auxiliares para mostrar/ocultar paneles
func _show_assignment_panel(visible: bool):
	if assignment_panel:
		assignment_panel.visible = visible
		floating_layer.visible = visible

func _show_event_panel(visible: bool):
	if event_panel:
		event_panel.visible = visible

func _show_results_panel(visible: bool):
	if results_panel:
		results_panel.visible = visible

func _show_game_over_panel(visible: bool):
	if game_over_panel:
		game_over_panel.visible = visible
