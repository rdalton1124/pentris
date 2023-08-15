extends Button

@onready var on = self.get_node("musicOn")
@onready var off = self.get_node("musicOff")
@onready var ac = get_node("../AudioController")
func _ready():
	off.visible = false
	
func _toggled(button_pressed):
	ac.toggleMusic()
	on.visible = not on.visible
	off.visible = not off.visible 	
