extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if (
			 event is InputEventKey
		or event is InputEventJoypadButton
		or event is InputEventMouseButton
	):
		print(event)
		print(event.pressed)
		if event.pressed:
			start_game()

func _on_StartTimer_timeout():
	$LetterAnimationPlayer.play("Letters")

func start_game():
	get_tree().change_scene("res://Game.tscn")
