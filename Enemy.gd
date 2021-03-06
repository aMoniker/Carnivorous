extends RigidBody2D
class_name Enemy

signal killed_enemy(immunity_value)

export var min_speed = 100
export var max_speed = 100
export var immunity_value = 0.1

var death1 = preload("res://assets/audio/death-1.wav")
var death2 = preload("res://assets/audio/death-2.wav")
var death3 = preload("res://assets/audio/death-3.wav")
var death4 = preload("res://assets/audio/death-4.wav")
var death_sounds = [death1, death2, death3, death4]

var dead = false
var rot_dir = 1
var rot_speed = 1

const rot_speed_max = 0.11
const rot_speed_min = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	rot_dir = [-1, 1][randi() % 2]
	rot_speed = rand_range(rot_speed_min, rot_speed_max)

func _process(delta):
	$Sprite.rotation += PI * 2 * delta * rot_dir * rot_speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Enemy_body_entered(node: Node):
	if node.is_in_group('bullets'):
		die()

func die(play_sound = true):
	self.collision_mask = 0
	self.collision_layer = 0
	$Tween.interpolate_property($Sprite, "modulate",
	  Color(1, 1, 1, 1), Color(1, 0, 0, 0), 0.33,
	  Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if (play_sound):
		var death_sound = death_sounds[randi() % death_sounds.size()]
		play_sound(death_sound)
	dead = true
	var player = get_node("../../Player")
	self.connect("killed_enemy", player, "_on_player_killed_enemy")
	emit_signal("killed_enemy", immunity_value)
	$DeathTimer.start()

func play_sound(sound: Resource):
	$Sound.stream = sound
	$Sound.play()

func _on_DeathTimer_timeout():
	queue_free();
