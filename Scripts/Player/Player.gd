
extends Node2D

export var speed = 100.0
#const SPEED = 100.0
var __level_width
var __level_height

func _ready():
	var root = get_tree().get_root().get_node("SceneRoot")
	__level_width = root.level_width
	__level_height = root.level_height
	
	set_fixed_process(true);

func _fixed_process(delta):
	var dir = Vector2()
	var pos = get_pos()
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")

	if (!(left or right or up or down)):
		return

	if (up):
		dir += Vector2(0, -1)

	if (down):
		dir += Vector2(0, 1)

	if (left):
		dir += Vector2(-1, 0)

	if (right):
		dir += Vector2(1, 0)

	pos += dir * delta * speed

	#var size = get_viewport_rect().size
	#var size2 = get_viewport_rect().pos
	#var size3 = get_tree().get_node("/root").get_camera().get_size()
	#var size3 = get_viewport().get_camera().get_size()
	#var bg = get_node("/root/SceneRoot/Background").get_region_rect()
	
	#print("LEVEL_WIDTH: ", __level_width, "\nLEVEL_HEIGHT: ", __level_height)
	
	pos.x = clamp(pos.x, -__level_width, __level_width)
	pos.y = clamp(pos.y, -__level_height, __level_height)
	#pos.x = clamp(pos.x, 0, size.x)
	#pos.x = clamp(pos.x, -size3.x, size3.x)
	#pos.y = clamp(pos.y, 0, size.y)

	print(pos)
	set_pos(pos)

#	var rect = get_viewport_rect()
#	translate(dir * delta * SPEED)
