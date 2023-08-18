extends Button

@onready var on = self.get_node("audioOn")
@onready var off = self.get_node("audioOff")
@onready var ac = get_node("../AudioController")

func _ready(): 
	off.visible = false 
	
func start_false():
	off.visible = true 
	on.visible = false 
func _pressed():
	ac.toggleSound() 
	on.visible = not on.visible 
	off.visible = not off.visible 
