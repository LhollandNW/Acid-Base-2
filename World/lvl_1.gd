extends Node2D
signal projectile_finished
@onready var fullHeart = preload("res://healthFull.png")
@onready var halfHeart = preload("res://healthHalf.png")
@onready var points = 0
@onready var player_dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_score():
	if not player_dead:
		points += 1
	$CanvasLayer/PanelContainer/HBoxContainer/Score.text = "Score:\n" + str(points)
func update_lives(lives: int):
	print(lives)
	if lives == 6:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(fullHeart)
	elif lives == 5:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(halfHeart)
	elif lives == 4:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives == 3:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(halfHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives == 2:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(fullHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(null)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives == 1:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(halfHeart)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(null)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(null)
	elif lives <= 0:
		$CanvasLayer/PanelContainer/HBoxContainer/First.set_texture(null)
		$CanvasLayer/PanelContainer/HBoxContainer/Second.set_texture(null)
		$CanvasLayer/PanelContainer/HBoxContainer/Third.set_texture(null)


func _on_projectile_finished():
	update_score()
	player_dead = false;
