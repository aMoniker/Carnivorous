extends MarginContainer

var player = null
var health = 0
var immunity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	player.connect("health_change", self, "_on_player_health_change")
	player.connect("immunity_change", self, "_on_player_immunity_change")
	health = player.health
	immunity = player.immunity

func _process(_delta):
	$HBoxContainer/HealthControl/HealthProgress.value = health
	$HBoxContainer/ImmunityControl/ImmunityProgress.value = immunity

func _on_player_health_change(amt):
	$HealthTween.interpolate_property(
		self, "health", health, amt, 0.5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	if not $HealthTween.is_active():
		$HealthTween.start()

func _on_player_immunity_change(amt):
	$ImmunityTween.interpolate_property(
		self, "immunity", immunity, amt, 0.5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	if not $ImmunityTween.is_active():
		$ImmunityTween.start()
