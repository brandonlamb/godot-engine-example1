extends RigidBody2D

const FORWARD_ACCELERATION = 100
const SIDEWARD_ACCELERATION = 15
const BACKWARD_ACCELERATION = 50
const ROTATIONAL_ACCELERATION = 2
const ROTATIONAL_BRAKING = 2
const APPRECIABLE = 0.01

var __thrust_vector
var __linear_velocity
var __angular_velocity

func _ready():
	pass

func _integrate_forces(state):
	reset_engines()
	calculate_movement(state)
	calculate_rotation(state)
	calculate_exhaust_trails(state)
	update_camera_zoom()

func reset_engines():
	get_node("front_exhaust").set_emitting(false)
	get_node("front_left_exhaust").set_emitting(false)
	get_node("front_right_exhaust").set_emitting(false)
	get_node("back_left_exhaust").set_emitting(false)
	get_node("back_right_exhaust").set_emitting(false)
	get_node("rear_exhaust_1").set_emitting(false)
	get_node("rear_exhaust_2").set_emitting(false)

func calculate_movement(state):
	__linear_velocity = state.get_linear_velocity()
	__angular_velocity = state.get_angular_velocity()
	__thrust_vector = Vector2(0,0)
	var step = state.get_step()

	#print("lv=", __linear_velocity, ", av=", __angular_velocity)

	var ship_forward = Input.is_action_pressed("ship_forward")
	var ship_backward = Input.is_action_pressed("ship_backward")
	var ship_strafe_left = Input.is_action_pressed("ship_strafe_left")
	var ship_strafe_right = Input.is_action_pressed("ship_strafe_right")

	if (ship_forward):
		__thrust_vector.x = sin(self.get_rot())
		__thrust_vector.y = cos(self.get_rot())
		__linear_velocity.y -= (FORWARD_ACCELERATION * __thrust_vector.y * step)
		__linear_velocity.x -= (FORWARD_ACCELERATION * __thrust_vector.x * step)
		get_node("rear_exhaust_1").set_emitting(true)
		get_node("rear_exhaust_2").set_emitting(true)

	if (ship_backward):
		__thrust_vector.x = sin(self.get_rot())
		__thrust_vector.y = cos(self.get_rot())
		__linear_velocity.y += (BACKWARD_ACCELERATION * __thrust_vector.y * step)
		__linear_velocity.x += (BACKWARD_ACCELERATION * __thrust_vector.x * step)
		get_node("front_exhaust").set_emitting(true)

	if (ship_strafe_left):
		__thrust_vector.x = sin(self.get_rot() + deg2rad(90))
		__thrust_vector.y = cos(self.get_rot() + deg2rad(90))
		__linear_velocity.y -= (SIDEWARD_ACCELERATION * __thrust_vector.y * step)
		__linear_velocity.x -= (SIDEWARD_ACCELERATION * __thrust_vector.x * step)
		get_node("front_right_exhaust").set_emitting(true)
		get_node("back_right_exhaust").set_emitting(true)

	if (ship_strafe_right):
		__thrust_vector.x = sin(self.get_rot() - deg2rad(90))
		__thrust_vector.y = cos(self.get_rot() - deg2rad(90))
		__linear_velocity.y -= (SIDEWARD_ACCELERATION * __thrust_vector.y * step)
		__linear_velocity.x -= (SIDEWARD_ACCELERATION * __thrust_vector.x * step)
		get_node("front_left_exhaust").set_emitting(true)
		get_node("back_left_exhaust").set_emitting(true)

	state.set_linear_velocity(__linear_velocity)
	__apply_brakes(ship_forward, ship_backward, state, step)

func __apply_brakes(ship_forward, ship_backward, state, step):
	if (ship_forward || ship_backward):
		print("dont brake")
		return

	print("braking: ", __linear_velocity)
	__linear_velocity = Vector2(0, 0)
	state.set_linear_velocity(__linear_velocity)

func __apply_brakes_old(ship_forward, ship_backward, state, step):
	if (ship_forward || ship_backward || __linear_velocity.x == 0 || __linear_velocity.y == 0):
		print("dont brake")
		return

	print("braking: ", __linear_velocity)
	
	if (__linear_velocity.x > 0):
		#__linear_velocity.x -= (BACKWARD_ACCELERATION * __thrust_vector.x * step)
		#__linear_velocity.x -= 0.1 * BACKWARD_ACCELERATION * step
		var x = __linear_velocity.x - 0.01 * step
		__linear_velocity.x = clamp(x, 0.01, 1.0)
	else:
		#__linear_velocity.x += (BACKWARD_ACCELERATION * __thrust_vector.x * step)
		#__linear_velocity.x += 0.1 * BACKWARD_ACCELERATION * step
		var x = __linear_velocity.x + 0.01 * step
		__linear_velocity.x = clamp(x, 0.01, 1.0)

	if (__linear_velocity.y > 0):
		__linear_velocity.y -= (BACKWARD_ACCELERATION * __thrust_vector.y * step)
	else:
		__linear_velocity.y += (BACKWARD_ACCELERATION * __thrust_vector.y * step)

	state.set_linear_velocity(__linear_velocity)

func calculate_rotation(state):
	var av = state.get_angular_velocity()
	var step = state.get_step()
	var ship_rotate_left  = Input.is_action_pressed("ship_rotate_left")
	var ship_rotate_right = Input.is_action_pressed("ship_rotate_right")

	if (ship_rotate_left and ship_rotate_right):
		pass
	elif (ship_rotate_left):
		av -= (ROTATIONAL_ACCELERATION * step)
		get_node("front_right_exhaust").set_emitting(true)
		get_node("back_left_exhaust").set_emitting(true)
	elif (ship_rotate_right):
		av += (ROTATIONAL_ACCELERATION * step)
		get_node("front_left_exhaust").set_emitting(true)
		get_node("back_right_exhaust").set_emitting(true)
	else:
		# If we have an appreciable
		if (av > -APPRECIABLE and av < APPRECIABLE):
			pass
		elif (av > APPRECIABLE): # Turn left
			av -= (ROTATIONAL_BRAKING * step)
			get_node("front_right_exhaust").set_emitting(true)
			get_node("back_left_exhaust").set_emitting(true)
		else: # Turn right
			av += (ROTATIONAL_BRAKING * step)
			get_node("front_left_exhaust").set_emitting(true)
			get_node("back_right_exhaust").set_emitting(true)

	state.set_angular_velocity(av)

func calculate_exhaust_trails(state):
	var lv = state.get_linear_velocity()
	var direction_angle = rad2deg(Vector2(0,0).angle_to(lv))
	var facing_angle = rad2deg(self.get_rot())
	var exhaust_trail = direction_angle - facing_angle
	var force_acting_on_exhaust = lv.length() * 10

	get_node("front_exhaust").set_param(5, exhaust_trail)
	get_node("front_left_exhaust").set_param(5, exhaust_trail)
	get_node("front_right_exhaust").set_param(5, exhaust_trail)
	get_node("back_left_exhaust").set_param(5, exhaust_trail)
	get_node("back_right_exhaust").set_param(5, exhaust_trail)
	get_node("rear_exhaust_1").set_param(5, exhaust_trail)
	get_node("rear_exhaust_2").set_param(5, exhaust_trail)

	get_node("front_exhaust").set_param(6, force_acting_on_exhaust)
	get_node("front_left_exhaust").set_param(6, force_acting_on_exhaust)
	get_node("front_right_exhaust").set_param(6, force_acting_on_exhaust)
	get_node("back_left_exhaust").set_param(6, force_acting_on_exhaust)
	get_node("back_right_exhaust").set_param(6, force_acting_on_exhaust)
	get_node("rear_exhaust_1").set_param(6, force_acting_on_exhaust)
	get_node("rear_exhaust_2").set_param(6, force_acting_on_exhaust)

func update_camera_zoom():
	var zoom_out = Input.is_action_pressed("camera_zoom_out")
	var zoom_in  = Input.is_action_pressed("camera_zoom_in")
	var camera = get_tree().get_root().get_node("SceneRoot/Camera2D")
	var zoom     = camera.get_zoom()

	if (zoom_out or zoom_in):
		if (zoom_out):
			zoom.x += 0.1
			zoom.y += 0.1
		elif (zoom_in and zoom.x > 1):
			zoom.x -= 0.1
			zoom.y -= 0.1

		camera.set_zoom(zoom)
