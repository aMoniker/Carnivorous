extends Node

signal joy_move(x, y)
signal joy_shoot(dir)

const joy_axis_deadzone = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	self._process_movement()
	self._process_shooting()

func _process_movement():
	# TODO implement mouse movement
	var mouse_down = Input.is_mouse_button_pressed(BUTTON_LEFT)
	if mouse_down:
		print("mouse down")

	var x = Input.get_joy_axis(0, JOY_AXIS_0)
	var y = Input.get_joy_axis(0, JOY_AXIS_1)
	if Vector2(x, y).length() > joy_axis_deadzone:
		emit_signal("joy_move", x, y)

func _process_shooting():
	# TODO implement mouse shooting
	var x = Input.get_joy_axis(0, JOY_AXIS_2)
	var y = Input.get_joy_axis(0, JOY_AXIS_3)
	if Vector2(x, y).length() > joy_axis_deadzone:
		emit_signal("joy_shoot", Vector2(x, y).normalized())
