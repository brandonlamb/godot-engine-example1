
extends RigidBody2D

export var speed = 10.0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")

	if (!(left or right or up or down)):
		return

	var pos = get_pos()
	
	if (up):
		apply_impulse(pos, Vector2(0, -speed))

	if (down):
		apply_impulse(pos, Vector2(0, speed))

	if (left):
		apply_impulse(pos, Vector2(-speed, 0))

	if (right):
		apply_impulse(pos, Vector2(speed, 0))
