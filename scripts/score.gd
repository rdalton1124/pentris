extends LineEdit

@onready var hi_score = get_node("../high_score")
var score

func _ready():
	score = 0
	printText() 

func setScore(nwScr):
	if(nwScr > 0):
		score = nwScr
	hi_score.new_score(score)
	printText()

func printText(): 
	self.text = "Lines: " + str(score)
