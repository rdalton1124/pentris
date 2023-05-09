extends Node
@onready var RNG = RandomNumberGenerator.new()
func _ready():
	RNG.randomize()
	spawn()
func spawn(): 
	var nwPiece = RNG.randi_range(1, 18)
	var scene = load("res://pentaminos/pentamino" + str(nwPiece) + ".tscn")
	var instance = scene.instantiate()
	instance.set_name("block")
	add_child(instance)
