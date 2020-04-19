extends Area2D

signal health_change(amt)
signal immunity_change(amt)

export var health = 100
export var immunity = 0
export var max_immunity = 100
export var health_per_hit = 23

var max_speed = 5
var bullet_spawn_dist = 50
const bullet = preload("res://Bullet.tscn")

var shoot1 = preload("res://assets/audio/shoot-1.wav")
var shoot2 = preload("res://assets/audio/shoot-2.wav")
var shoot3 = preload("res://assets/audio/shoot-3.wav")
var shoot4 = preload("res://assets/audio/shoot-4.wav")
var shoot5 = preload("res://assets/audio/shoot-5.wav")
var normal_shots = [shoot1, shoot2, shoot3, shoot4]

var ouch1 = preload("res://assets/audio/ouch-1.wav")
var ouch2 = preload("res://assets/audio/ouch-2.wav")
var ouch_sounds = [ouch1, ouch2]

var death4 = preload("res://assets/audio/death-4.wav")

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if health <= 0:
		die()

func _on_Controller_joy_move(joy_x, joy_y):
	if dead:
		return

	var x = self.position.x
	var y = self.position.y
	var new_x = x + (joy_x * max_speed)
	var new_y = y + (joy_y * max_speed)
	self.position = Vector2(new_x, new_y)

func _on_Controller_joy_shoot(dir: Vector2):
	if dead:
		return

	$Sprite.rotation = dir.angle()
	if not $BulletTimer.is_stopped():
		return
	var spawn_point = Vector2(
		dir.x * bullet_spawn_dist, dir.y * bullet_spawn_dist
	)
	self.shoot(spawn_point, dir)

func _on_BulletTimer_timeout():
	$BulletTimer.stop()

func _on_Player_body_entered(node: Node):
	if node.is_in_group('enemies'):
		player_hit()
		node.die(false)

func _on_player_killed_enemy(immunity_increase):
	print('player killed enemy')
	immunity += immunity_increase
	emit_signal("immunity_change", immunity)

func shoot(spawn: Vector2, dir: Vector2):
	var b = bullet.instance()
	b.init(self.position + spawn, dir)
	var root = get_tree().get_root()
	root.add_child(b)
	$BulletTimer.start()
	$ShootSound.stream = normal_shots[randi() % normal_shots.size()]
	$ShootSound.play()

func player_hit():
	health = max(0, health - health_per_hit)
	emit_signal("health_change", health)
	$HitSound.stream = ouch2
	$HitSound.play()
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1, 1, 1, 1), Color(1, 0, 0, 1), 0.1,
		Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_completed")
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1, 0, 0, 1), Color(1, 1, 1, 1), 0.1,
		Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()

func die():
	if dead:
		return
	dead = true
	self.collision_mask = 0
	self.collision_layer = 0
	$DeathSound.stream = death4;
	$DeathSound.play()
	$Tween.interpolate_property($Sprite, "modulate",
		Color(1, 1, 1, 1), Color(1, 0, 0, 0), 1.0,
		Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($DeathSound, "finished")
	yield($Tween, "tween_completed")
	queue_free()
