extends "res://Enemy.gd"

export var hits_to_heal = 3

var hit1 = preload("res://assets/audio/hit-1.wav")
var squish2 = preload("res://assets/audio/squish-2.wav")

func _on_Enemy_body_entered(node: Node):
	if node.is_in_group('bullets'):
		hits_to_heal -= 1
		if hits_to_heal == 0:
			heal()
		else:
			play_sound(hit1)
	elif node.is_in_group('player'):
		die()

func die(play_sound = true):
	$AnimationPlayer.stop()
	.die()

func heal(play_sound = true):
	self.collision_mask = 0
	self.collision_layer = 0
	var direction = 0
	self.rotation = direction
	self.linear_velocity = Vector2(500, 0)
	self.linear_velocity = self.linear_velocity.rotated(direction)
	$AnimationPlayer.stop()
	$Tween.interpolate_property($Sprite, "modulate",
	  $Sprite.modulate, Color(1, 1, 1, 1), 0.33,
	  Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	if (play_sound):
		play_sound(squish2)
	var player = get_node("../../Player")
	self.connect("killed_enemy", player, "_on_player_killed_enemy")
	emit_signal("killed_enemy", immunity_value)
