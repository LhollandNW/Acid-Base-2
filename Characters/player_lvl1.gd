extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties")
@export var move_speed : float = 320
@export var jump_force : float = 800
@export var gravity : float = 1800
@onready var attack_animation_duration_timer = $AttackAnimationDurationTimer
@onready var anim = $AnimatedSprite2D
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles
@onready var sword = $SwordHurtbox/Box
var positionA = Vector2(175, 400)
var positionB = Vector2(20, 200)
var positionC = Vector2(100, 100)

var t = 0.0
var duration = 1.0
var dodging = false
var returning = false
var attacking = false

var player_attacks = [
	'Attack_1',
	'Attack_2',
	'Attack_3'
]
# --------- BUILT-IN FUNCTIONS ---------- #
func _physics_process(_delta):
	# Calling functions
	movement(_delta)
	#flip_player()
	if Input.is_action_just_pressed("Attack") and is_on_floor():
		if not attacking:
			attacking = true
			anim.play(player_attacks[randi()%3])
			sword.disabled=false
			return
	elif Input.is_action_just_pressed("Dodge") and is_on_floor():
		positionA = self.position
		dodging = true
		anim.play("Dodge")
		pass
	elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right") and is_on_floor():
		anim.play("Idle")
	if is_on_floor() and anim.animation == "Fall":
		anim.play("Idle") 
	elif !is_on_floor() and anim.animation != "Jump" and not dodging and not returning:
		anim.play("Fall")
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		anim.play("Jump")
		jump()
		attacking = false
	if dodging:
		t += _delta / duration
		var q0 = positionA.lerp(positionC, min(t, 1.0))
		var q1 = positionC.lerp(positionB, min(t, 1.0))
		self.position = q0.lerp(q1, min(t, 1.0))
		anim.flip_h = true
		if self.position == positionB:
			anim.play("Wall_Cling")
			await get_tree().create_timer(1).timeout
			t = 0.0
			returning = true
			anim.flip_h = false
			dodging = false
	if returning:
		anim.play("Dodge")
		t += _delta / duration
		var q0 = positionB.lerp(positionC, min(t, 1.0))
		var q1 = positionC.lerp(positionA, min(t, 1.0))
		self.position = q0.lerp(q1, min(t, 1.0))
		if self.position == positionA:
			anim.play("Idle")
			returning = false
			positionA = self.position
			t=0.0
			

func _on_AnimatedSprite_animation_finished():
	if anim.animation in player_attacks:
		attacking = false
		sword.disabled=true
		anim.play("Idle")
	elif anim.animation == "Jump" and !is_on_floor():
		anim.play("Fall")
		return  # Skip the rest of the function to avoid playing "Idle" for jumps
	elif anim.animation == "Dodge" and is_on_floor():
		anim.play("Idle")
	elif anim.animation == "Dodge":
		anim.play("Dodge")
	elif returning:
		anim.play("Dodge")
	elif anim.animation == "Wall_Cling":
		anim.play("Wall_Cling")
	elif anim.animation == "Fall " and !is_on_floor():
		anim.play("Fall")
	elif anim.animation == "Walk" and Input.is_action_pressed("Right") or Input.is_action_pressed("Left"):
		pass
	else:
		anim.play("Idle")
		
# <-- Player Movement Code -->
func movement(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# Move Player
	if not attacking:
		var inputAxis = Input.get_axis("Left", "Right")
		velocity = Vector2(inputAxis * move_speed, velocity.y)
		move_and_slide()

# Player jump
func jump():
	if is_on_floor():
		jump_tween()
	velocity.y = -jump_force
	
func flip_player():
	if velocity.x < 0 and not attacking: 
		anim.flip_h = true
	elif velocity.x > 0 and not attacking:
		anim.flip_h = false

# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	set_position(Vector2(175, 0))
	await get_tree().create_timer(1).timeout
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 
	
func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_sword_hurtbox_body_entered(body):
	pass # Replace with function body.

func _on_player_hitbox_body_entered(body):
	pass # Replace with function body.
