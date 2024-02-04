extends Button

@onready var on = self.get_node("musicOn")
@onready var off = self.get_node("musicOff")
@onready var ac = get_node("../AudioController")
func _ready():
	off.visible = false
func start_false(): 
	off.visible = true
	on.visible = false 
func _pressed():
	ac.toggleMusic()
	on.visible = not on.visible
	off.visible = not off.visible 	
