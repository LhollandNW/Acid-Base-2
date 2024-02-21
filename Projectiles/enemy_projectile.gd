extends RigidBody2D

var positionA = Vector2(0, 0)
var positionC = Vector2(-400, -200)
var positionB = Vector2(-850, 38)
var t = 0.0
var duration = 3.0
var handled = false
var compoundArray = [["AgCl","Neutral"],["BaCrO₄","Base"],["CCl₄","Neutral"],["HClO₄","Acid"],["CO₂H","Acid"],["HNO₂","Acid"],["C₃H₈","Neutral"],["CH₃COOH","Acid"],["MgC₂O₄","Base"],["HCN","Acid"],["CH₄","Neutral"],["CaCO₃","Base"],["Na₂S","Base"],["K₂SO₃","Base"],["CH₃-NH₂","Base"],["Mg(OH)₂","Base"],["HCl","Acid"],["HNO₃","Acid"],["K₃PO₄","Base"],["KNO₃","Neutral"],["KNO₂","Base"],["NaBr","Neutral"],["KMnO₄","Base"],["Ca(ClO₃)₂","Base"],["H₂O","Both"]]
@onready var formula = $FormulaLabel
@onready var projectile_sprite = $AnimatedSprite2D
@onready var projectile = self
@onready var acidExplosion = $Explosion/Acid
@onready var baseExplosion = $Explosion/Base
@onready var acidParticles = $Explosion/AcidParticles
@onready var baseParticles = $Explosion/BaseParticles
@onready var neutralParticles = $Explosion/NeutralParticles

func _ready():
	acidParticles.emitting = false
	baseParticles.emitting = false
	neutralParticles.emitting = false
	acidExplosion.disabled
	baseExplosion.disabled
	var selection = randi_range(0, compoundArray.size() - 1)
	add_to_group(compoundArray[selection][1])
	formula.text = compoundArray[selection][1]
	if ((compoundArray[selection][1])=="Acid"):
		projectile_sprite.play("Acid")
	pass # Replace with function body.
	
func _physics_process(delta):
	rotation = 0.00
	t += delta / duration
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	self.position = q0.lerp(q1, min(t, 1.0))
	
	if (self.position == positionB):
		
		if not handled:
			if is_in_group("Acid"):
				acidParticles.emitting=true
				acidExplosion.disabled=false
				handled = true
			
			if is_in_group("Base"):
				baseParticles.emitting=true
				baseExplosion.disabled=false
				handled = true
			
		if is_in_group("Both"):
			neutralParticles.emitting=true
			
		if is_in_group("Neutral"):
			neutralParticles.emitting=true
			
		formula.hide()
		disable()
		await get_tree().create_timer(0.5).timeout
		acidExplosion.disabled=true
		baseExplosion.disabled=true
		await get_tree().create_timer(3).timeout
		queue_free()
		handled=false

func _on_area_2d_body_entered(body):
	var group = get_groups()[0]
	print("Hit with " + group)
	
func _on_explosion_body_entered(body):
	body.death_tween() # Replace with function body.
	
func disable():
	projectile_sprite.hide()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
