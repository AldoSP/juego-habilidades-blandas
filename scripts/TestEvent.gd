func trigger_event():
	print("Evento: Sofia quiere descansar")
	
	var decision = true # simula elección
	
	if decision:
		team.characters[2].energy += 10
	else:
		print("Sofia sigue trabajando")
