
extends Camera2D

const __EDGE_BUFFER = 250.0

var __root
var __level_width
var __level_height
var __player

func _ready():
	__root = get_tree().get_root().get_node("SceneRoot")
	__level_width = __root.level_width
	__level_height = __root.level_height
	__player = root.get_node("Player")

	set_fixed_process(true)

func _fixed_process(delta):
	var dir = Vector2()
	var pos = __player.get_pos()
	var x = 0
	var y = 0

	print("POS: ", pos)

	# Prevent camera from going past edge of level
	var diff_left = -__level_width - pos.x
	var diff_right = __level_width - pos.x
	if (diff_left < -__EDGE_BUFFER || diff_right > __EDGE_BUFFER):
		pos.x = clamp(pos.x, -__level_width + (__EDGE_BUFFER * 1.9), __level_width - (__EDGE_BUFFER * 1.9))

	var diff_up = -__level_height - pos.y
	var diff_down = __level_height - pos.y
	if (diff_up < -__EDGE_BUFFER || diff_down > __EDGE_BUFFER):
		pos.y = clamp(pos.y, -__level_height + __EDGE_BUFFER, __level_height - __EDGE_BUFFER)

	print("CAM: ", pos)
	set_pos(pos)
