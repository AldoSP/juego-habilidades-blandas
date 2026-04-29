extends Node

var assignments = {} # character_id -> category_id

func assign(character_id, category_id):
	assignments[character_id] = category_id

func reset():
	assignments.clear()

func get_characters_in_category(category_id):
	var result = []
	for char_id in assignments:
		if assignments[char_id] == category_id:
			result.append(char_id)
	return result
