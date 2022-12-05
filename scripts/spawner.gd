extends Node
var RNG
func _ready():
	RNG = RandomNumberGenerator.new()
	RNG.randomize()
	
func spawn(): 
	var nwPiece = RNG.randi()
	nwPiece %= 18
	nwPiece += 1
	var scene = load("res://pentaminos/pentamino" + str(nwPiece) + ".tscn")
	var instance = scene.instance()
	instance.set_name("block")
	add_child(instance)
