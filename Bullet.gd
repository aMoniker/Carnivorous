extends RigidBody2D

var sprite
var speed = 777
var rot_dir = 1
const radians_per_sec = PI * 2 * 2 # rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = self.get_node("Sprite")
	rot_dir = [-1, 1][randi() % 2]

func init(pos: Vector2, dir: Vector2):
	self.position = pos
	self.linear_velocity = Vector2(speed, 0)
	self.linear_velocity = self.linear_velocity.rotated(dir.angle())

func _process(delta):
	sprite.rotation += radians_per_sec * delta * rot_dir

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
