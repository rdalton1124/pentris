extends KinematicBody2D

var xOffset 
var yOffset 

func _ready(): 
	xOffset = self.position.x 
	yOffset = self.position.y 
	$CollisionShape2D.set_disabled(true)
func _physics_process(delta):
	self.position.x = xOffset
	self.position.y = yOffset
func move() :
	self.set_physics_process(false)
	$CollisionShape2D.set_disabled(false)
