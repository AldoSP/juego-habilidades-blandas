extends Node

#Este es el sistema que controla las metas del proyecto

var programming = 0
var design = 0
var testing = 0

var target_programming = 20
var target_design = 20
var target_testing = 20

func set_targets(prog: int, des: int, test: int):
	target_programming = prog
	target_design = des
	target_testing = test

func get_progress() -> Dictionary:
	return {
		"programming": programming,
		"design": design,
		"testing": testing
	}

func get_targets() -> Dictionary:
	return {
		"programming": target_programming,
		"design": target_design,
		"testing": target_testing
	}

func is_complete() -> bool:
	return programming >= target_programming \
		and design >= target_design \
		and testing >= target_testing

func get_completion_summary() -> Dictionary:
	return {
		"programming": { "current": programming, "target": target_programming, "met": programming >= target_programming },
		"design": { "current": design, "target": target_design, "met": design >= target_design },
		"testing": { "current": testing, "target": target_testing, "met": testing >= target_testing }
	}

func apply_results(results):
	programming += results["programming"]
	design += results["design"]
	testing += results["testing"]
	print("current programming: ", programming, "/", target_programming)
	print("current design: ", design, "/", target_design)
	print("current testing: ", testing, "/", target_testing)
