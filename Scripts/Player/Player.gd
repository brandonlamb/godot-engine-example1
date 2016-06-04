
extends Node2D

export var speed = 100.0

const __EDGE_BUFFER = 250.0

var __root
var __level_width
var __level_height
var __camera

func _ready():
	__root = get_tree().get_root().get_node("SceneRoot")
	__camera = __root.get_node("Camera2D")
	__level_width = __root.level_width
	__level_height = __root.level_height

	set_fixed_process(true);

func _fixed_process(delta):
	var dir = Vector2()
	var pos = get_pos()
	var cam = Vector2()
	var x = 0
	var y = 0
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
	pos.x = clamp(pos.x, -__level_width, __level_width)
	pos.y = clamp(pos.y, -__level_height, __level_height)

	# Prevent camera from going past edge of level
	var diff_left = -__level_width - pos.x
	var diff_right = __level_width - pos.x
	if (diff_left < -__EDGE_BUFFER || diff_right > __EDGE_BUFFER):
		x = clamp(pos.x, -__level_width + (__EDGE_BUFFER * 1.9), __level_width - (__EDGE_BUFFER * 1.9))
		cam.x = x

	var diff_up = -__level_height - pos.y
	var diff_down = __level_height - pos.y
	if (diff_up < -__EDGE_BUFFER || diff_down > __EDGE_BUFFER):
		y = clamp(pos.y, -__level_height + __EDGE_BUFFER, __level_height - __EDGE_BUFFER)
		cam.y = y

	print("POS: ", pos)
	print("CAM: ", x, ",", y)
	set_pos(pos)
	__camera.set_pos(cam)

#	var rect = get_viewport_rect()
#	translate(dir * delta * SPEED)
