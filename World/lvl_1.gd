extends Node2D
signal projectile_finished
@onready var fullHeart = preload("res://healthFull.png")
@onready var halfHeart = preload("res://healthHalf.png")
@onready var points = 0
@onready var player_dead = false
	
func update_score():
	if not player_dead:
		points += 1
	$HUD/PanelContainer/HBoxContainer/Score.text = "Score:\n" + str(points)
	gameover()
	
func update_lives(lives: int):
	if lives == 6:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(fullHeart)
	elif lives == 5:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(halfHeart)
	elif lives == 4:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives == 3:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(halfHeart)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives == 2:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(null)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives == 1:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(halfHeart)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(null)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives <= 0:
		$HUD/PanelContainer/HBoxContainer/First.set_texture(null)
		$HUD/PanelContainer/HBoxContainer/Second.set_texture(null)
		$HUD/PanelContainer/HBoxContainer/Third.set_texture(null)
		gameover()
		
func _on_projectile_finished():
	update_score()
	player_dead = false;
	
func gameover():
	#stop physics
	#call hud gameover
	$HUD.game_over()
	pass
func restart():
	#start physics
	#reset values
	#call hud game_start
	$player_Lvl1.lives = 6
	update_lives(6)
	pass
