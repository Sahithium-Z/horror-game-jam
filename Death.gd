extends Control

onready var score = get_node("Label2")

func _process(delta):
	score.text = str(get_parent().score)
