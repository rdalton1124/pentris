extends Button

@onready var on = self.get_node("musicOn")
@onready var off = self.get_node("musicOff")
@onready var isMusic = true 

func _ready():
	off.visible = false
	
func _toggled(button_pressed):
	isMusic = not isMusic
	on.visible = isMusic
	off.visible = not isMusic
	
