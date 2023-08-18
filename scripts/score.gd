extends LineEdit

var style = StyleBoxFlat.new() 
@onready var hi_score = get_node("../high_score")
var score
func _ready():
	style.set_bg_color(Color(0,0,0,0))
	set("custom_styles/normal", style)
	score = 0
	printText() 
func increment(): 
	score += 1
	printText()
	hi_score.new_score(score)

func setScore(nwScr):
	if(nwScr > 0):
		score = nwScr
	hi_score.new_score(score)
	printText()
func printText(): 
	self.text = "Lines: " + str(score)
