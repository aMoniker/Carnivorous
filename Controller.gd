extends Node2D

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
	# Keyboard movement
	var u = Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	var d = Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)
	var l = Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)
	var r = Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)
	var key_move = Vector2(0, 0)
	if u:
		key_move.y = -1
	elif d:
		key_move.y = 1
	if r:
		key_move.x = 1
	elif l:
		key_move.x = -1
	if key_move.length():
		key_move = key_move.normalized()
		emit_signal("joy_move", key_move.x, key_move.y)
		return

	# Joystick movement
	var x = Input.get_joy_axis(0, JOY_AXIS_0)
	var y = Input.get_joy_axis(0, JOY_AXIS_1)
	if Vector2(x, y).length() > joy_axis_deadzone:
		emit_signal("joy_move", x, y)

func _process_shooting():
	# Mouse shooting
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_dir = self.get_local_mouse_position().normalized()
		emit_signal("joy_shoot", mouse_dir)
		return

	# Joystick shooting
	var x = Input.get_joy_axis(0, JOY_AXIS_2)
	var y = Input.get_joy_axis(0, JOY_AXIS_3)
	if Vector2(x, y).length() > joy_axis_deadzone:
		emit_signal("joy_shoot", Vector2(x, y).normalized())
