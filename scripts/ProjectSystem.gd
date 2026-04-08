extends Node

#Este es el sistema que controla las metas del proyecto

var programming = 0
var design = 0
var testing = 0

func apply_results(results):
	programming += results["programming"]
	design += results["design"]
	testing += results["testing"]
	print("current programming: ", programming)
	print("current design: ", design)
	print("current testing: ", testing)
