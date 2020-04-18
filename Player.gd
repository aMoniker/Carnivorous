extends Node2D

var max_speed = 5
var bullet_spawn_dist = 50
const bullet = preload("res://Bullet.tscn")

var shoot1 = preload("res://assets/audio/shoot-1.wav")
var shoot2 = preload("res://assets/audio/shoot-2.wav")
var shoot3 = preload("res://assets/audio/shoot-3.wav")
var shoot4 = preload("res://assets/audio/shoot-4.wav")
var shoot5 = preload("res://assets/audio/shoot-5.wav")

var normal_shots = [shoot1, shoot2, shoot3, shoot4]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Controller_joy_move(joy_x, joy_y):
	var x = self.position.x
	var y = self.position.y
	var new_x = x + (joy_x * max_speed)
	var new_y = y + (joy_y * max_speed)
	self.position = Vector2(new_x, new_y)

func _on_Controller_joy_shoot(dir: Vector2):
	$Sprite.rotation = dir.angle()
	if not $BulletTimer.is_stopped():
		return
	var spawn_point = Vector2(
		dir.x * bullet_spawn_dist, dir.y * bullet_spawn_dist
	)
	self.shoot(spawn_point, dir)

func _on_BulletTimer_timeout():
	$BulletTimer.stop()

func shoot(spawn: Vector2, dir: Vector2):
	var b = bullet.instance()
	b.init(self.position + spawn, dir)
	var root = get_tree().get_root()
	root.add_child(b)
	$BulletTimer.start()
	var shoot_sound = normal_shots[randi() % normal_shots.size()]
	play_sound(shoot_sound)

func play_sound(sound: Resource):
	$Sound.stream = sound
	$Sound.play()
