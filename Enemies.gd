extends Node2D

var Mob = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
  $MobPath/MobSpawnLocation.offset = randi()
  var mob = Mob.instance()
  add_child(mob)
  var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
  mob.position = $MobPath/MobSpawnLocation.position
  direction += rand_range(-PI / 4, PI / 4)
  mob.rotation = direction
  mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
  mob.linear_velocity = mob.linear_velocity.rotated(direction)
