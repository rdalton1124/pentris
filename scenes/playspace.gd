extends Node2D



var array = [] 
var linesCleared = 0
func _ready():
	for i in range(0, 16): 
		array.append(0)
		
	print(array.size())

func rstarry():
	for i in range(0, 16): 
		array[i] = 0

func checkLines(): 
	var lineArray = []
	rstarry()
	for i in get_child_count(): 
		var h = (get_child(i).position.y)
		var index = h2in(h)
		array[index] += 1
		if(array[index] == 13): 
			print("line made")
			lineArray.append(index)
	deleteLines(lineArray)
	linesCleared += lineArray.size()
func deleteLines(arry): 
	var toDel = [] 
	for i in get_child_count(): 
		for j in arry: 
			var h = get_child(i).position.y 
			if (in2h(j) == h): 
				toDel.append(i)
	
	if toDel.size() != arry.size() * 13: 
		print("error in deletion array")
		print("deletion array should contain " + str(arry.size() * 13))
		print("actually contains  " + str(toDel.size()))

	var s = toDel.size()
	for i in toDel:
		get_child(i).queue_free()
	
	
	if s:
		for i in arry:
			for j in get_child_count():
				if get_child(j).position.y <= in2h(i):
					get_child(j).fall()

func h2in(x):
	return ((x - 28) / 32) - 1
func in2h(x):
	return (32 * (x + 1)) + 28
func printStatus():
	print (str(self.get_child_count()))
