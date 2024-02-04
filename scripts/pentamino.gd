extends CharacterBody2D

var angle
var x 
var y

var fall_speed
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
	fall_speed = 60
	set_up_direction(Vector2.UP)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(50)
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
			var coll_name = get_slide_collision(i).get_collider().name
			if(coll_name == "wall_left" && !leftColl):
				ac.bump()
				hSnap() 
				leftColl = true 
				rightColl = false
			elif(coll_name == "wall_right" && !rightColl): 
				ac.bump()
				hSnap()
				rightColl = true
				leftColl = false
			else: 
				rightColl = false
				leftColl = false


func speed_up(): 
	fall_speed += 5

#enforces the grid. If piece becomes misaligned, aligns it to an appropriate place.
func snap(): 
	hSnap()
	vSnap()

#horizontal snap.
#turns x into the closest multiple of 32
func hSnap(): 
	var tX = round(self.position.x)
	if(fmod(self.position.x, 32) < 16):
		self.position.x -= fmod(self.position.x, 32)
	else:
		self.position.x += 32 - fmod(self.position.x, 32)
	self.position.x = round(self.position.x)

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
	downSnap()
	if (self.position.y > 10): #if haven't reached top 
		find_parent("spawn").spawn() # spawn new piece 
		
	#remove collisionh 
	self.remove_child($CollisionPolygon2D)
	
	#as long as pentamino has blocks left 
	while self.get_child_count() > 0: 
		#child is last element of array
		var child  = self.get_child(self.get_child_count() - 1) 
		#global coordinates 
		var newX = child.global_position.x
		var newY = child.global_position.y 
		
		child.lock()
		#give block to playspace
		self.remove_child(child)
		playfield.add_child(child)
		#change blocks' position to global
		child.global_position.x = newX 
		child.global_position.y = newY 

	playfield.checkLines() #playfield checks lines 
	self.queue_free() #remove pentamino object 

func processInput(delta):
	velocity.x = 0
	
	#rotations
	if(Input.is_action_just_pressed("cc_rotate")):
		angle += 90
	elif(Input.is_action_just_pressed("ccw_rotate")):
		angle -= 90
	
	if(Input.is_action_pressed("move_left", false) && !leftColl):
		#if inputs ahas been held for .25sec or recently inputted		
		if time_elapsed - last_left > .25 or Input.is_action_just_pressed("move_left"): 
			position.x -= 32  #move left
			last_left = time_elapsed #reset time held 
	elif(Input.is_action_pressed("move_right", false) && !rightColl):
		#if input has been held or just inputted 
		if time_elapsed - last_right > .25 or Input.is_action_just_pressed("move_right"): 
			position.x += 32 # move right 
			last_right = time_elapsed #reset time held 
			
	#set fall speed according to user input
	if(Input.is_action_just_pressed("quick_drop")):
		#quick drop by massively increasing false speed 
		velocity.y = fall_speed * 1000
		velocity.x = 0 
		ac.qd() 
		move_and_slide() 
		lock()  
	elif(Input.is_action_pressed("fall_faster")):
		velocity.y = fall_speed * 2
	else:
		velocity.y = fall_speed


