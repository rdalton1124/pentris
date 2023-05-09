extends CharacterBody2D

var angle
var x 
var y

var fallSpeed

var leftColl:bool = false
var rightColl:bool = false

var oldY = 100000

@onready var qd = get_node("../../audio/quickDrop")
@onready var wallBump = get_node("../../audio/wall_bump")
@onready var playfield = get_node("../../playspace")

var stuckCount = 0

func _ready():
	angle = rotation_degrees
	x = self.position.x
	y = self.position.y
	velocity = Vector2.ZERO
	fallSpeed = 60

func _physics_process(delta):
	processInput()
	if is_on_wall(): 
		for i in range(get_slide_collision_count() - 1):
			var name = get_slide_collision(i).get_collider().name
			if(name == "wall_left" && !leftColl):
				wallBump.play()
				hSnap()
				leftColl = true 
			elif(name == "wall_right" && !rightColl): 
				wallBump.play()
				hSnap()
				rightColl = true

	self.rotation_degrees = angle
	
	oldY = round(self.position.y)
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(20)
	set_floor_max_angle(deg_to_rad(30))
	move_and_slide()
	
	y = round(self.position.y)
	
	#if Y has moved up somehow, snap it back down. 
	#remove control when block hits bottom. 
	if is_on_floor():
		lock()
	elif round(oldY) >= round(y): 
		downSnap()
		stuckCount += 1
		if stuckCount >= 10:
			lock()
	else:
		stuckCount = 0

func speed_up(): 
	fallSpeed += 5

#enforces the grid. If piece becomes misaligned, aligns it to an appropriate place.
func snap(): 
	hSnap()
	vSnap()

#horizontal snap.
#turns x into the closest multiple of 32
func hSnap(): 
	if(fmod(self.position.x, 32) <= 16):
		self.position.x -= fmod(self.position.x, 32)
	else:
		self.position.x += 32 - fmod(self.position.x, 32)


#vertical snap
#turns y to the closest multiple of 32
func vSnap():
	if(fmod(self.position.y, 32) <= 16):
		self.position.y -= fmod(self.position.y, 32)
	else:
		self.position.y += 32 - fmod(self.position.y, 32)

#turns x to closest multiple of 32 and 
#ceils y down the next multiple of 32. 
#meant to help with a piece that is stuck between 2 otherpieces
func downSnap():
	self.position.y += 32 - fmod(self.position.y, 32)

#remove player control and spawn a new piece. 
func lock(): 
	vSnap()
	self.position.x = round(self.position.x)
	if(fmod(self.position.x, 32)):
		print("Abnormal x posiion, x = " + str(self.position.x))
		hSnap()
	if (self.position.y > 10):
		find_parent("spawn").spawn() # spawn new piece 
	#printStatus()
	self.remove_child($CollisionPolygon2D)
	while self.get_child_count() > 0: 
		var chile = self.get_child(self.get_child_count() - 1) 
		var newX = chile.global_position.x
		var newY = chile.global_position.y 
		chile.move()
		self.remove_child(chile)
		playfield.add_child(chile)
		chile.global_position.x = newX 
		chile.global_position.y = newY 

	playfield.checkLines()
	self.queue_free()

func processInput():
	velocity.x = 0
	if(Input.is_action_just_pressed("cc_rotate")):
		angle += 90
	if(Input.is_action_just_pressed("ccw_rotate")):
		angle -= 90
	if(Input.is_action_just_pressed("move_left") && !leftColl):
		velocity.x = -32 * 60
		rightColl = false
	if(Input.is_action_just_pressed("move_right") && !rightColl):
		velocity.x = 32 * 60
		leftColl = false
	if(Input.is_action_just_pressed("quick_drop")):
		velocity.y = fallSpeed * 1000
		qd.play()
	elif(Input.is_action_pressed("fall_faster")):
		velocity.y = fallSpeed * 2
	else:
		velocity.y = fallSpeed

func printStatus():
	print("x = "  + str(self.position.x))
	print("y = " + str(self.position.y))
	print("rotation ~" + str(self.rotation_degrees))
	print("hitting a floor?" + str(is_on_floor()))
	print("hitting a wall? " + str(is_on_wall()))
	for i in get_slide_collision_count(): 
		print("collision: " + get_slide_collision(i).collider.name)
		print("collision angle " + str(get_slide_collision(i).get_angle()))
	print("")
	
