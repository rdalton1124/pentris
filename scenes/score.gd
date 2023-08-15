extends LineEdit

var style = StyleBoxFlat.new() 
var score
func _ready():
	style.set_bg_color(Color(0,0,0,0))
	set("custom_styles/normal", style)
	score = 0
	printText() 
	
func increment(): 
	score += 1
	printText()
func setScore(nwScr):
	if(nwScr > 0):
		score = nwScr
	printText()
func printText(): 
	self.text = "Lines: " + str(score)
