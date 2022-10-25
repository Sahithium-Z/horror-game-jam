extends KinematicBody2D

export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 8
export(int) var AIR_FRICTION = 1
export(int) var GRAVITY = 4
export(int) var FASTFALL_GRAV = 2

onready var collision = get_node("Hitbox/CollisionShape2D")
onready var collision2 = get_node("Hitbox/CollisionShape2D2")

var velocity = Vector2.ZERO
onready var delay = false

signal i_died

func _ready():
	collision.disabled = true
	collision2.disabled = true

func _physics_process(delta):
	apply_gravity()
#	if Input.is_action_just_pressed("ui_down"):
#		fall_through()
#		apply_gravity()
#	elif Input.is_action_just_released("ui_down"):
#		cancel_fall_through()
	
		
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
	
	if Input.is_action_just_pressed("ui_accept"):
		if !delay:
			print("ATTTACKK")
			collision.disabled = false
			collision2.disabled = false
			var t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t,"timeout")
			t.queue_free()
			collision.disabled = true
			collision2.disabled = true
			delay = true
			var u = Timer.new()
			u.set_wait_time(1)
			u.set_one_shot(true)
			self.add_child(u)
			u.start()
			yield(u,"timeout")
			u.queue_free()
			delay = false
	
		

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

#func cancel_fall_through():Score
	#if get_collision_mask_bit(2) == false:
	#	set_collision_mask_bit(2, true)
		
func hold(x):
	var t = Timer.new()
	t.set_wait_time(x)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t,"timeout")
	t.queue_free()


func _on_Hurtbox_area_entered(area):
	emit_signal("i_died")
	#queue_free()
