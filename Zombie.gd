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
#	if Input.is_action_just_pressed("ui_down"):
#		fall_through()
#		apply_gravity()
#	elif Input.is_action_just_released("ui_down"):
#		cancel_fall_through()
	
	#if "res://Player/Player.tscn".
	var movement = Vector2.ZERO
	
	movement.x = get_parent().get_node("Player").position.x - self.position.x
	if movement.x > 0.3:
		movement.x = 0.3
	elif movement.x < -0.3:
		movement.x = -0.3
		
	if movement.x == 0:
		apply_friction()
	else:
		apply_acceleration(movement.x)
		
	movement.y == get_parent().get_node("Player").position.y - self.position.y
	#print(get_parent().get_node("Player").position.y)
	#print(self.position.y)
	#print(get_parent().get_node("Player").position.y - self.position.y)
	#print(movement.y)
	
	if is_on_floor() && get_parent().get_node("Player").position.y - self.position.y < -16:
		velocity.y = JUMP_FORCE
	else:
		if velocity.y > 0:
			velocity.y += FASTFALL_GRAV

#	if is_on_floor():
#		if Input.is_action_just_pressed("ui_up"):
#			velocity.y = JUMP_FORCE
#	else:
##		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
#			velocity.y = JUMP_RELEASE_FORCE
		
#		if velocity.y > 0:
#			velocity.y += FASTFALL_GRAV
	
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
	
func fall_through():
	if is_on_floor():
		set_collision_mask_bit(2, false)

func cancel_fall_through():
	if get_collision_mask_bit(2) == false:
		set_collision_mask_bit(2, true)


func _on_Hurtbox_area_entered(area):
	get_parent().score += 1
	queue_free()
