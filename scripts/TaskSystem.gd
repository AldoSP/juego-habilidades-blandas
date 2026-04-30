extends Node

#Aquí está la logica con la que se calcula una tarea dado un personaje y su tipo de tarea

func calculate_task(character, task_type):
	var base = 5
	var multiplier = 1.0

	if task_type == character.strength:
		multiplier = 1.5
	elif task_type == character.weakness:
		multiplier = 0.5

	if character.energy < 30:
		multiplier *= 0.5
	
	print(character.name, " energía: ", character.energy)

	var score = int(base * multiplier) + character.event_modifier
	if score < 0:
		score = 0
	return score

func resolve_all(characters):
	var results = {
		"programming": 0,
		"design": 0,
		"testing": 0
	}

	for c in characters:
		if c.assigned_task == null:
			continue

		if c.assigned_task == "rest":
			# Rest no contribuye puntos al proyecto, pero restaura energía
			c.set_energy(c.energy + 20)  # Emitir señal para actualizar UI al instante
			c.event_modifier = 0
			continue

		var value = calculate_task(c, c.assigned_task)
		results[c.assigned_task] += value
		c.set_energy(c.energy - 10)
		#c.energy -= 10
		c.event_modifier = 0
	
	return results
