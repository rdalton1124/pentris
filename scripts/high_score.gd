extends LineEdit 

var hi_score 
func _ready(): 
	hi_score = 0
	self.load() 
	printText()   
func load(): 
	var save = FileAccess.open("user://high_score.save", FileAccess.READ)
	save = save.get_as_text()
	var json = JSON.new() 
	var lod = json.parse(save, false)
	if lod == OK: 
		var dat = json.data 
		hi_score = dat.hi_score 
func saveHi(): 
	var saveGame = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	var saveDict = {
		"hi_score": hi_score
	}
	saveGame.store_line(JSON.stringify(saveDict))
func new_score(score): 
	if score > hi_score: 
		hi_score = score
		
	printText() 
func printText(): 
	self.text = "High: " + str(hi_score)

