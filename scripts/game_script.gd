extends Node2D

@onready var hi_score = get_node('high_score')
func isLineMadee(): 
	var line:bool = false 

func _process(delta): 
	if(Input.is_action_just_pressed("restart")): 
		hi_score.saveHi()
		get_tree().reload_current_scene()
	if(Input.is_action_just_pressed("hold")): 
		pass 
