extends Area2D

signal health_change(amt)
signal immunity_change(amt)
signal player_died()
signal player_won()
signal printer_mode(active)

export var health = 100
export var immunity = 0
export var max_immunity = 100
export var health_per_hit = 23

var screen_size = null
var margin = 32

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
var won = false
var bullet_wait_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	bullet_wait_time = $BulletTimer.wait_time

func _process(_delta):
	if health <= 0:
		die()
	if immunity >= max_immunity:
		win()

func _on_Controller_joy_move(joy_x, joy_y):
	if dead or won:
		return

	var x = min(max(self.position.x, margin), screen_size.x - margin)
	var y = min(max(self.position.y, margin), screen_size.y - margin)
	var new_x = x + (joy_x * max_speed)
	var new_y = y + (joy_y * max_speed)
	self.position = Vector2(new_x, new_y)

func _on_Controller_joy_shoot(dir: Vector2):
	if dead or won:
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
	immunity += immunity_increase
	emit_signal("immunity_change", immunity)

func _on_player_healed_cell():
	$BulletTimer.wait_time = 0.1
	emit_signal("printer_mode", true)
	$PrinterTimer.start()

func _on_PrinterTimer_timeout():
	$BulletTimer.wait_time = bullet_wait_time
	emit_signal("printer_mode", false)

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
	emit_signal("player_died")
	queue_free()

func win():
	if won:
		return
	won = true
	self.collision_mask = 0
	self.collision_layer = 0
	emit_signal("player_won")
