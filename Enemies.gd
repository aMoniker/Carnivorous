extends Node2D

const WeakEnemy = preload("res://WeakEnemy.tscn")
const MediumEnemy = preload("res://MediumEnemy.tscn")
const HardEnemy = preload("res://HardEnemy.tscn")
const CellEnemy = preload("res://CellEnemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  $WeakEnemyTimer.start()
  $MediumEnemyTimer.start()
  $HardEnemyTimer.start()
  $CellEnemyTimer.start()

func spawnEnemy(Mob: PackedScene):
  $MobPath/MobSpawnLocation.offset = randi()
  var mob = Mob.instance()
  add_child(mob)
  var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
  mob.position = $MobPath/MobSpawnLocation.position
  direction += rand_range(-PI / 8, PI / 8)
  mob.rotation = direction
  mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
  mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_WeakEnemyTimer_timeout():
  spawnEnemy(WeakEnemy)

func _on_MediumEnemyTimer_timeout():
  spawnEnemy(MediumEnemy)

func _on_HardEnemyTimer_timeout():
  spawnEnemy(HardEnemy)

func _on_CellEnemyTimer_timeout():
  spawnEnemy(CellEnemy)
