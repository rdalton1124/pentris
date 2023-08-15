extends Node2D

@onready var qdSound = get_node("../audio/quickDrop")
@onready var bumpSound = get_node("../audio/wall_bump")
@onready var lineSound = get_node("../audio/line") 

var soundOn
var musicOn 

func _ready(): 
	soundOn = true
	musicOn = true

func toggleSound():
	soundOn = not soundOn
func toggleMusic():
	musicOn = not musicOn

func qd(): 
	if soundOn: 
			qdSound.play()
func line(): 
	if soundOn:
		lineSound.play()

func bump(): 
	if soundOn:
		bumpSound.play() 	
