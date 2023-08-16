extends CharacterBody2D

var angle
var x 
var y

var fallSpeed
var last_left = 0 
var last_right = 0 
var time_elapsed = 0
var leftColl:bool = false
var rightColl:bool = false

var oldY = 100000

@onready var ac = get_node("../../AudioController")
@onready var playfield = get_node("../../playspace")

var stuckCount = 0

func _ready():
	angle = rotation_degrees
	x = self.position.x
	y = self.position.y
	velocity = Vector2.ZERO
	fallSpeed = 60
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(20)
	set_floor_max_angle(deg_to_rad(30))
	
func _physics_process(delta):
	processInput(delta)
	setColls() 
	self.rotation_degrees = angle
	
	oldY = round(self.position.y)

	move_and_slide()
	
	y = round(self.position.y)
	
	#if Y has moved up somehow, snap it back down. 
	#remove control when block hits bottom. 
	if is_on_floor():
		setColls() 
		velocity.y = 0 
		processInput(delta)
		move_and_slide()
		lock() 	
	elif round(oldY) >= round(y): 
		downSnap()
		stuckCount += 1
		if stuckCount >= 10:
			lock()
	else:
		stuckCount = 0
	time_elapsed += delta 
#allows player to input a last move before 
# piece is locked in
func lastMove(delta):
	if(Input.is_action_pressed("move_left") and not leftColl):
		velocity.x = - 32 / delta
	elif(Input.is_action_pressed("move_right") and not rightColl):
		velocity.x = 32 / delta 
	move_and_slide() 
#Sets variables which tell whether 
# you are collisding with left and right walls
func setColls(): 
	if is_on_wall(): 
		for i in range(get_slide_collision_count() - 1):
			var name = get_slide_collision(i).get_collider().name
			if(name == "wall_left" && !leftColl):
				ac.bump()
				hSnap() 
				leftColl = true 
				rightColl = false
			elif(name == "wall_right" && !rightColl): 
				ac.bump()
				hSnap()
				rightColl = true
				leftColl = false
			else: 
				rightColl = false
				leftColl = false


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
	snap() 
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

func processInput(delta):
	velocity.x = 0
	if(Input.is_action_just_pressed("cc_rotate")):
		angle += 90
	elif(Input.is_action_just_pressed("ccw_rotate")):
		angle -= 90
	if(Input.is_action_pressed("move_left", false) && !leftColl):
		if time_elapsed - last_left > .25 or Input.is_action_just_pressed("move_left"): 
			velocity.x = -32 / delta
			last_left = time_elapsed 
	elif(Input.is_action_pressed("move_right", false) && !rightColl):
		if time_elapsed - last_right > .25 or Input.is_action_just_pressed("move_right"): 
			velocity.x = 32 /delta 
			last_right = time_elapsed 
		#await(get_tree().create_timer(1).timeout)
	if(Input.is_action_just_pressed("quick_drop")):
		velocity.y = fallSpeed * 1000
		ac.qd() 
	elif(Input.is_action_pressed("fall_faster")):
		velocity.y = fallSpeed * 2
	else:
		velocity.y = fallSpeed


