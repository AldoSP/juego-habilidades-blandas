extends Node

#Este es el orquestrador de todo el juego

@onready var team = $TeamSystem
@onready var tasks = $TaskSystem
@onready var project = $ProjectSystem

var day = 1
var max_days = 3

func _ready():
	run_game()

func run_game():
	while day <= max_days:
		print("Día ", day)
		
		assign_tasks()
		
		var results = tasks.resolve_all(team.characters)
		project.apply_results(results)
		
		print(results)
		
		day += 1

func assign_tasks():
	for c in team.characters:
		# Temporal: asignación automática
		c.assigned_task = ["programming", "design", "testing"].pick_random()
		print(c.name, " Assigned to ", c.assigned_task) 
