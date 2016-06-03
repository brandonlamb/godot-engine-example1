
extends Node2D

export var speed = 100.0
const SPEED = 100.0

func _ready():
	set_fixed_process(true);

func _fixed_process(delta):
	var dir = Vector2()
	var pos = get_pos()

	if (Input.is_action_pressed("move_down")):
		dir += Vector2(0, 1)
	elif (Input.is_action_pressed("move_up")):
		dir += Vector2(0, -1)
	elif (Input.is_action_pressed("move_left")):
		dir += Vector2(-1, 0)
	elif (Input.is_action_pressed("move_right")):
		dir += Vector2(1, 0)

	pos += dir * delta * SPEED

	var size = get_viewport_rect().size
	var size2 = get_viewport_rect().pos
	#var size3 = get_tree().get_node("/root").get_camera().get_size()
	#var size3 = get_viewport().get_camera().get_size()
	
	#pos.x = clamp(pos.x, 0, size.x)
	#pos.x = clamp(pos.x, -size3.x, size3.x)
	#pos.y = clamp(pos.y, 0, size.y)

	set_pos(pos)

#	var rect = get_viewport_rect()
#	translate(dir * delta * SPEED)
