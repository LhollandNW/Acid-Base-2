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
					["BaCrO[font_size=10]4[/font_size]","Base"],
					["CCl[font_size=10]4[/font_size]","Neutral"],
					["HClO[font_size=10]4[/font_size]","Acid"],
					["CO[font_size=10]2[/font_size]H","Acid"],
					["HNO[font_size=10]2[/font_size]","Acid"],
					["C[font_size=10]3[/font_size]H[font_size=10]8[/font_size]","Neutral"],
					["CH[font_size=10]3[/font_size]COOH","Acid"],
					["MgC[font_size=10]2[/font_size]O[font_size=10]4[/font_size]","Base"],
					["HCN","Acid"],
					["CH[font_size=10]4[/font_size]","Neutral"],
					["CaCO[font_size=10]3[/font_size]","Base"],
					["Na[font_size=10]2[/font_size]S","Base"],
					["K[font_size=10]2[/font_size]SO[font_size=10]3[/font_size]","Base"],
					["CH[font_size=10]3[/font_size]-NH[font_size=10]2[/font_size]","Base"],
					["Mg(OH)[font_size=10]2[/font_size]","Base"],
					["HCl","Acid"],
					["HNO[font_size=10]3[/font_size]","Acid"],
					["K[font_size=10]3[/font_size]PO[font_size=10]4[/font_size]","Base"],
					["KNO[font_size=10]3[/font_size]","Neutral"],
					["KNO[font_size=10]2[/font_size]","Base"],
					["NaBr","Neutral"],
					["KMnO[font_size=10]4[/font_size]","Base"],
					["Ca(ClO[font_size=10]3[/font_size])[font_size=10]2[/font_size]","Base"],
					["H[font_size=10]2[/font_size]O","Both"]
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
	formula.text = "[center]" + compoundArray[selection][0] + "[/center]"
	
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
	
