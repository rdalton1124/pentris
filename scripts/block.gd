extends CharacterBody2D

var xOffset 
var yOffset 
var vel = Vector2.ZERO 
var landed = false
func _ready(): 
	vel.y = 32
	xOffset = self.position.x 
	yOffset = self.position.y 
	$CollisionShape2D.set_disabled(true)
func _physics_process(delta):
	if !landed: 
		self.position.x = xOffset
		self.position.y = yOffset
func move() :
	self.set_physics_process(false)
	$CollisionShape2D.set_disabled(false)
	landed = true 
func fall(): 
	self.position.y += 32
