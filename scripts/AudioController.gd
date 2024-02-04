extends Node2D

@onready var qdSound = get_node("../audio/quickDrop")
@onready var bumpSound = get_node("../audio/wall_bump")
@onready var lineSound = get_node("../audio/line") 
@onready var music = get_node("../audio/musicAudio")
var soundOn
var musicOn 

func _ready(): 
	soundOn = true
	musicOn = true
	music.play()

func get_sound(): 
	return soundOn 
func get_music(): 
	return musicOn 

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
func _process(_delta):
	if not musicOn: 
		music.stop() 
	elif musicOn and not music.is_playing():
		music.play() 
	
