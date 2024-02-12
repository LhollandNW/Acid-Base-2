extends RigidBody2D

var positionA = Vector2(0, 0)
var positionC = Vector2(-400, -200)
var positionB = Vector2(-850, 30)
var t = 0.0
var duration = 3.0
var compoundArray = [["AgCl","Neutral"],["BaCrO₄","Base"],["CCl₄","Neutral"],["HClO₄","Acid"],["CO₂H","Acid"],["HNO₂","Acid"],["C₃H₈","Neutral"],["CH₃COOH","Acid"],["MgC₂O₄","Base"],["HCN","Acid"],["CH₄","Neutral"],["CaCO₃","Base"],["Na₂S","Base"],["K₂SO₃","Base"],["CH₃-NH₂","Base"],["Mg(OH)₂","Base"],["HCl","Acid"],["HNO₃","Acid"],["K₃PO₄","Base"],["KNO₃","Neutral"],["KNO₂","Base"],["NaBr","Neutral"],["KMnO₄","Base"],["Ca(ClO₃)₂","Base"],["H₂O","Both"]]
@onready var formula = $FormulaLabel
@onready var projectile_sprite = $AnimatedSprite2D
@onready var projectile = self
@onready var acidExplosion = $Explosion/Acid
@onready var baseExplosion = $Explosion/Base

func _ready():
	acidExplosion.disabled
	baseExplosion.disabled
	var selection = randi_range(0, compoundArray.size() - 1)
	add_to_group(compoundArray[selection][1])
	formula.text = compoundArray[selection][0]
	if ((compoundArray[selection][1])=="Acid"):
		projectile_sprite.play("Acid")
	pass # Replace with function body.
	
func _physics_process(delta):
	t += delta / duration
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	self.position = q0.lerp(q1, min(t, 1.0))
	if (self.position == positionB):
		if is_in_group("Acid"):
			print("Acid Boom")
			acidExplosion.disabled=false
		if is_in_group("Base"):
			print("Base Boom")
			baseExplosion.disabled=false
		if is_in_group("Both"):
			print("Acid or Base Boom?")
		if is_in_group("Neutral"):
			print("Nothing")
		queue_free()

func _on_area_2d_body_entered(body):
	print(body)
	if body.is_in_group("Player") or body.is_in_group("Sword"):
		queue_free()
	 # Replace with function body.
