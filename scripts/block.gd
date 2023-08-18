extends CharacterBody2D
''' 
	One of the individual blocks which makes up the pentamino 
	This script serves primarily to take control of the 
'''
var xOffset 
var yOffset 
var landed = false
func _ready(): 
	xOffset = self.position.x 
	yOffset = self.position.y 
	$CollisionPolygon2D.set_disabled(true)
func _physics_process(_delta):
	if !landed: 
		self.position.x = xOffset
		self.position.y = yOffset
func move() :
	self.set_physics_process(false)
	$CollisionPolygon2D.set_disabled(false)
	landed = true 
func fall(): 
	self.position.y += 32
