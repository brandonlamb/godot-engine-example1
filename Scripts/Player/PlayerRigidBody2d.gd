
extends RigidBody2D

export var speed = 100.0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")

	if (!(left or right or up or down)):
		return

	if (up):
		apply_impulse(get_pos(), Vector2(0, -1))

	if (down):
		apply_impulse(get_pos(), Vector2(0, 1))

	if (left):
		apply_impulse(get_pos(), Vector2(-1, 0))

	if (right):
		apply_impulse(get_pos(), Vector2(1, 0))
