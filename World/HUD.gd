extends CanvasLayer

@onready var gameOverScreen = $GameOverScreen
@onready var inGamePanel = $PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	gameOverScreen.hide()
	pass
func _process(delta):
	pass
	
func game_start():
	inGamePanel.show()
	gameOverScreen.hide()
	$"..".restart()
	pass
	
func game_over():
	inGamePanel.hide()
	gameOverScreen.show()
	pass
	

func _on_restart_pressed():
	game_start()
	pass # Replace with function body.


func _on_main_menu_pressed():
	pass # Replace with function body.


func _on_tutorial_pressed():
	pass # Replace with function body.
