extends CharacterBody2D
''' 
	One of the individual blocks which makes up the pentamino 
	This script serves primarily to take control of the 
'''
#offset from parent object
var xOffset 
var yOffset 

func _ready(): 
	xOffset = self.position.x 
	yOffset = self.position.y 
	#collision starts out off because
	#parent hav collsiion 
	$CollisionPolygon2D.set_disabled(true)

func lock() :
	$CollisionPolygon2D.set_disabled(false)
	
func fall(): 
	self.position.y += 32
