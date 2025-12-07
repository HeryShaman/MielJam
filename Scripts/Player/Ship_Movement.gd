extends CharacterBody2D

@export var Speed : float = 2.5
@export var RotSpeed : float = 0.05
@export_range(0,1) var Friction : float = 0.99

@export var DeathParticles : PackedScene

@onready var sfx_start_move: AudioStreamPlayer = $sfx_start_move
@onready var sfx_move_backward: AudioStreamPlayer = $sfx_moveBackward
@onready var sfx_death_explode: AudioStreamPlayer = $sfx_death_explode
@onready var sfx_fly_loop: AudioStreamPlayer = $sfx_fly_loop
var rotation_sound_has_played = false
var movement_sound_has_played = false
var timer_sound : float = 0
@export var cooldown_sound = 0.2

var Wishvel1 : Vector2 = Vector2.ZERO
var Wishvel2 : Vector2 = Vector2.ZERO
var ShipDir : Vector2 = Vector2.ZERO

var LastCheckPoint : Vector2

var HasDied : bool = false

@onready var RocketArea: Area2D = $Area2D

func ProcessInput():
	Wishvel1 = Vector2.ZERO
	# Définition des inputs
	if Input.is_action_pressed("forward 1"):
		Wishvel1.y -= 1
	if Input.is_action_pressed("backward 1"):
		Wishvel1.y += 1
	if Input.is_action_pressed("left 1"):
		Wishvel1.x -= 1
	if Input.is_action_pressed("right 1"):
		Wishvel1.x += 1
	
	
	Wishvel2 = Vector2.ZERO
	# Définition des inputs
	if Input.is_action_pressed("forward 2"):
		Wishvel2.y -= 1
	if Input.is_action_pressed("backward 2"):
		Wishvel2.y += 1
	if Input.is_action_pressed("left 2"):
		Wishvel2.x -= 1
	if Input.is_action_pressed("right 2"):
		Wishvel2.x += 1
	
	ShipDir = Vector2.ZERO
	
	# P1 Right + P2 Left = Ship Forward
	if Wishvel1.x > 0.1 and Wishvel2.x < -0.1:
		ShipDir.y = -1
		
	# P1 Left + P2 Right = Ship Down
	if Wishvel1.x < -0.1 and Wishvel2.x > 0.1:
		ShipDir.y = 1
	
	## P1 Up + P2 Down = Ship Right
	#if Wishvel1.y > 0.1 and Wishvel2.y < -0.1:
		#ShipDir.x = 1
		#
	## P1 Down + P2 Up = Ship Left
	#if Wishvel1.y < -0.1 and Wishvel2.y > 0.1:
		#ShipDir.x = -1
		
func _ready() -> void:
	if LastCheckPoint == Vector2.ZERO:
		LastCheckPoint = global_position

func _physics_process(_delta: float) -> void:
	ProcessInput()
	if HasDied:
		visible = false
		velocity.x = 0
		velocity.y = 0
	else:
		visible = true
		Move()
	
	#print(Wishvel1, Wishvel2)
	#print(ShipDir)
	
func Move():
	if Wishvel1.y < -0.1 and Wishvel2.y > 0.1:
		rotate(RotSpeed)
		
	if Wishvel1.y > 0.1 and Wishvel2.y < -0.1:
		rotate(-RotSpeed)
		
	if ShipDir.length() > 0.1:
		velocity += ShipDir.rotated(rotation) * Speed
		if!movement_sound_has_played:
			sfx_start_move.play()
			movement_sound_has_played = true

		
	else:
		velocity *= Friction
		
	
	move_and_slide()

func OnRocketCollision(body: Node2D) -> void:
	if body.is_in_group("Environnement"):
		RespawnShip()

func RespawnShip():

	sfx_death_explode.play()
	movement_sound_has_played = false
	rotation_sound_has_played = false
	var explosionVFX = DeathParticles.instantiate()
	explosionVFX.position = global_position
	explosionVFX.rotation = global_rotation
	explosionVFX.emitting = true
	get_tree().current_scene.add_child(explosionVFX)
	HasDied = true
	
	await get_tree().create_timer(1.0).timeout
	HasDied = false
	global_position = LastCheckPoint
	velocity = Vector2.ZERO
	rotation = 0
	
