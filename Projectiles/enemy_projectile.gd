extends RigidBody2D

# --------- VARIABLES ---------- #
var positionA = Vector2(0, 0)
var positionC = Vector2(-400, -200)
var positionB = Vector2(-652, 44)
var t = 0.0
var duration = 3.0
@onready var handled = false
var compoundArray = [
					["AgCl","Neutral"],
					["BaCrO₄","Base"],
					["CCl₄","Neutral"],
					["HClO₄","Acid"],
					["CO₂H","Acid"],
					["HNO₂","Acid"],
					["C₃H₈","Neutral"],
					["CH₃COOH","Acid"],
					["MgC₂O₄","Base"],
					["HCN","Acid"],
					["CH₄","Neutral"],
					["CaCO₃","Base"],
					["Na₂S","Base"],
					["K₂SO₃","Base"],
					["CH₃-NH₂","Base"],
					["Mg(OH)₂","Base"],
					["HCl","Acid"],
					["HNO₃","Acid"],
					["K₃PO₄","Base"],
					["KNO₃","Neutral"],
					["KNO₂","Base"],
					["NaBr","Neutral"],
					["KMnO₄","Base"],
					["Ca(ClO₃)₂","Base"],
					["H₂O","Both"]
					] 
					#This list of chemical compounds can be expanded if need be.
					#To add more, simply create a string array of size 2, containing the compound itself,
					# as well as whether it is a  base, acid, neutral or both
					
@onready var formula = $FormulaLabel
@onready var projectile_sprite = $Sprite2D
@onready var projectile = self
@onready var acidExplosion = $Explosion/Acid
@onready var baseExplosion = $Explosion/Base
@onready var acidParticles = $Explosion/AcidParticles
@onready var baseParticles = $Explosion/BaseParticles
@onready var neutralParticles = $Explosion/NeutralParticles

# --------- FUNCTIONS ---------- #
func _ready():
	projectile_sprite.material.set_shader_parameter("active", false)
	acidParticles.emitting = false
	baseParticles.emitting = false
	neutralParticles.emitting = false
	acidExplosion.disabled
	baseExplosion.disabled
	var selection = randi_range(0, compoundArray.size() - 1)
	add_to_group(compoundArray[selection][1])
	formula.text = compoundArray[selection][0]
	
func _physics_process(delta):
	rotation = 0.00
	t += delta / duration
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	self.position = q0.lerp(q1, min(t, 1.0))
	
	if (self.position == positionB):
		if not handled:
			handled = true
			if is_in_group("Acid"):
				acidParticles.emitting=true
				await get_tree().create_timer(0.1).timeout
				acidExplosion.disabled=false
			
			if is_in_group("Base"):
				baseParticles.emitting=true
				await get_tree().create_timer(0.1).timeout
				baseExplosion.disabled=false
			
			if is_in_group("Both"):
				neutralParticles.emitting=true
			
			if is_in_group("Neutral"):
				neutralParticles.emitting=true
			await get_tree().create_timer(0.5).timeout
			$"..".projectile_finished.emit()
		formula.hide()
		disable()
		await get_tree().create_timer(0.5).timeout
		acidExplosion.disabled=true
		baseExplosion.disabled=true
		await get_tree().create_timer(3).timeout
		queue_free()
	
func _on_explosion_body_entered(body):
	body.ouch()
	
func disable():
	projectile_sprite.hide()
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	
func ouch():
	projectile_sprite.material.set_shader_parameter("active", true)
	set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	set_physics_process(true)
	queue_free()
	
