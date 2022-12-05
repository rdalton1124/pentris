extends Node
var RNG
func _ready():
	RNG = RandomNumberGenerator.new()
	RNG.randomize()
	
func spawn(): 
	var nwPiece = RNG.randi_range(1, 18)
	var scene = load("res://pentaminos/pentamino" + str(nwPiece) + ".tscn")
	var instance = scene.instance()
	instance.set_name("block")
	add_child(instance)
