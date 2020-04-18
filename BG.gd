extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	self.offset.x -= 1
	if abs(self.offset.x) == 160:
		self.offset.x = 0
