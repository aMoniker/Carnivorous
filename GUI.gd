extends Control

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	player.connect("health_change", self, "_on_player_health_change")

func _on_player_health_change(amt):
	$HealthLabel.text = str(amt)
