extends LineEdit 

@onready var ac = get_node("../AudioController")
@onready var sound = get_node("../sound")
@onready var music = get_node("../music")

var hi_score 

func _ready(): 
	hi_score = 0
	self.load_save() 
	printText()   
func load_save(): 
	var save = FileAccess.open("user://high_score.save", FileAccess.READ)
	save = save.get_as_text()
	var json = JSON.new() 
	var lod = json.parse(save, false)
	if lod == OK: 
		var dat = json.data 
		hi_score = dat.hi_score
		if not dat.music: 
			ac.toggleMusic() 
			music.start_false() 
		if not dat.sound: 
			ac.toggleSound() 
			sound.start_false() 
func saveHi(): 
	var saveGame = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	var saveDict = {
		"hi_score": hi_score,
		"music": ac.get_music(),
		"sound": ac.get_sound()
	}
	saveGame.store_line(JSON.stringify(saveDict))
func new_score(score): 
	if score > hi_score: 
		hi_score = score
		
	printText() 
func printText(): 
	self.text = "High: " + str(hi_score)

