extends Node

var game_over = false
var game_won = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _input(event):
	if not game_over and not game_won:
		return

	if (
			 event is InputEventKey
		or event is InputEventJoypadButton
		or event is InputEventMouseButton
	):
		if event.pressed:
			if game_over:
				start_game()
			elif game_won:
				restart_game()

func _on_Player_player_died():
	# show game over
	$GameOver.visible = true
	$RestartGame.visible = true
	game_over = true

func _on_Player_player_won():
	$Win.visible = true
	game_won = true

func start_game():
	get_tree().change_scene("res://Game.tscn")

func restart_game():
	get_tree().reload_current_scene()
