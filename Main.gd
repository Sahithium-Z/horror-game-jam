extends Node2D


var enemy = preload ("res://Zombie.tscn")
var score = 0
onready var death = get_node("Death")
	
func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	#print(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyTimer_timeout():
	var player = get_node("Player")
	var e = enemy.instance()
	var pos = player.position
	
	if randf() < 0.5:
		pos.x -= rand_range(48, 160)
		if pos.x < 20:
			pos.x = rand_range(180, 300)
	else:
		pos.x += rand_range(48, 160)
		if pos.x > 300:
			pos.x = rand_range(20, 120)
			
	e.position = pos
	add_child_below_node(player, e)


func _on_Player_i_died():
	death.visible = true
