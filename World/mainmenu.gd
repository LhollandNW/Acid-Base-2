extends CanvasLayer
# --------- VARIABLES ---------- #
var highscore = 0
# Called when the node enters the scene tree for the first time.

# --------- FUNCTIONS ---------- #
func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://World/lvl_1.tscn")
	pass # Replace with function body.

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://World/tutorial.tscn")
	pass # Replace with function body.

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://World/credits.tscn")
	pass # Replace with function body.
