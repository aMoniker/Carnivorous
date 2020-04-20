extends Node

var game_over = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print('game ready')
	randomize()

func _input(event):
	if not game_over:
		return

	if (
			 event is InputEventKey
		or event is InputEventJoypadButton
		or event is InputEventMouseButton
	):
		if event.pressed:
			start_game()

func _on_Player_player_died():
	# show game over
	$GameOver.visible = true
	$RestartGame.visible = true
	game_over = true

func start_game():
	get_tree().change_scene("res://Game.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
