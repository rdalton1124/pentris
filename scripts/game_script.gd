extends Node2D

func _ready():
	$spawn.spawn()
	
func isLineMade(): 
	var line:bool = false 
	
func _process(delta): 
	if(Input.is_action_just_pressed("restart")): 
		get_tree().reload_current_scene()
	if(Input.is_action_just_pressed("hold")): 
		pass 
