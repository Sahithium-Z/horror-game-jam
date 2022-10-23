extends KinematicBody2D

export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 8
export(int) var AIR_FRICTION = 1
export(int) var GRAVITY = 4
export(int) var FASTFALL_GRAV = 2

var velocity = Vector2.ZERO

func _physics_process(delta):
	apply_gravity()
	
	var input = Vector3.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += FASTFALL_GRAV
	
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += GRAVITY

func apply_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
