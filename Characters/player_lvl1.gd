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

var attacking = false

var player_attacks = [
	'Attack_1',
	'Attack_2',
	'Attack_3'
]


# --------- BUILT-IN FUNCTIONS ---------- #
func _process(_delta):
	# Calling functions
	movement(_delta)
	#flip_player()
	if Input.is_action_just_pressed("Attack") and is_on_floor():
		if not attacking:
			attacking = true
			anim.play(player_attacks[randi()%3])
			return
	elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right") and is_on_floor():
		anim.play("Idle")
	if is_on_floor() and anim.animation == "Fall":
		anim.play("Idle") 
	elif !is_on_floor() and anim.animation != "Jump":
		anim.play("Fall")
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		anim.play("Jump")
		jump()
		attacking = false
	
func _on_AnimatedSprite_animation_finished():
	if anim.animation in player_attacks:
		attacking = false
		anim.play("Idle")
	elif anim.animation == "Jump" and !is_on_floor():
		anim.play("Fall")
		return  # Skip the rest of the function to avoid playing "Idle" for jumps
	elif anim.animation == "Fall " and !is_on_floor():
		anim.play("Fall")
	elif anim.animation == "Walk" and Input.is_action_pressed("Right") or Input.is_action_pressed("Left"):
		pass
	else:
		anim.play("Idle")
		
# <-- Player Movement Code -->
func movement(delta):
	# Gravity
	if !is_on_floor():
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
	set_position(Vector2(159, 447))
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

func _on_collision_body_entered(_body):
	if _body.is_in_group("Map"):
		print("Touching wall")
	if _body.is_in_group("Acid"):
		print("Hit by Acid")
		death_tween()
	elif _body.is_in_group("Base"):
		print("Hit by Base")
		death_tween()
	elif _body.is_in_group("Both"):
		print("Hit by Both")
		death_tween()
	elif _body.is_in_group("Neutral"):
		print("Hit by Neutral")
		death_tween()
