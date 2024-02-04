extends Node2D

@onready var  score = get_node("../score")
@onready var ac = get_node("../AudioController")

const LINE_SIZE = 11
const WELL_HEIGHT = 16

var blocks_filled = []
var lines_cleared = 0

#crate empty array
func _ready():
	for i in range(0, WELL_HEIGHT): 
		blocks_filled.append(0)
func reset_arry():
	for i in range(0, WELL_HEIGHT): 
		blocks_filled[i] = 0

func checkLines(): 
	var lineArray = []
	reset_arry()
	for i in get_child_count(): 
		var h = (get_child(i).position.y)
		var index = h2in(h)
		blocks_filled[index] += 1
		if(blocks_filled[index] == LINE_SIZE): 
			lineArray.append(index)
	if lineArray.size(): 
		ac.line() 
	deleteLines(lineArray)
	lines_cleared += lineArray.size()
	score.setScore(lines_cleared)
func deleteLines(completed_lines): 
	var toDel = [] #to be deleted 
	#go through children. If
	#their height is that of a complete
	# linhe, delete them. 
	for i in get_child_count(): 
		for j in completed_lines: 
			var h = get_child(i).position.y 
			if (in2h(j) == h): 
				toDel.append(i)
	

	var s = toDel.size()
	#dlete
	for i in toDel:
		get_child(i).queue_free()
	
	var idx = completed_lines.size() - 1
	if s:
		while idx >= 0: 
			for j in get_child_count():
				if get_child(j).position.y <= in2h(completed_lines[idx]):
					get_child(j).fall()
			idx -= 1
			

#height to index function 
func h2in(x):
	return ((x - 28) / 32) - 1
#index to height function 
func in2h(x):
	return (32 * (x + 1)) + 28
