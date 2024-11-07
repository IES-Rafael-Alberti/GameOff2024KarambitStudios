extends CharacterBody2D

# --------------- Constantes ------------------
const SPEED = 130.0 # Velocidad del personaje
const JUMP_VELOCITY = -300.0 # Velocidad del salto
const DASH_SPEED = 300.0 # Velocidad del dash
const DASH_DURATION = 0.2 # Duración del dash (segundos)
const MAX_JUMPS = 2 # Máximo de saltos

#------------------- Variables ----------------
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var can_dash = true
var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0.0
var facing_right = true
var can_attack = true

#------------------ Cargar escenas -----------------
@onready var animated_sprite = $AnimatedSprite2D
@onready var colision_flash = $Flash/ColisionFlash
@onready var cooldown_attack = $Flash/CooldownAttack
@onready var timer = $Flash/AttackTime
@onready var sprite_2d = $Flash/ColisionFlash/Sprite2D


#------------------ Funciones -----------------
func _ready():
	colision_flash.disabled = true
	sprite_2d.visible = false
func _process(delta):
	# Actualiza la dirección del jugador cuando se mueve
	if Input.is_action_pressed("move_right"):
		facing_right = true
	elif Input.is_action_pressed("move_left"):
		facing_right = false

<<<<<<< Updated upstream
	# Handle jump.
	if Input.is_action_just_pressed("Jump"	) and is_on_floor():
=======
func _physics_process(delta):
	
	if Input.is_action_just_pressed("flashAttack") and can_attack:
		colision_flash.disabled = false
		sprite_2d.visible = true
		timer.start()
		can_attack = false
		cooldown_attack.start()
		print(timer.time_left)
		print(cooldown_attack.time_left)
	# Aplicar gravedad cuando no está en el suelo y no está en dash
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
	if is_on_floor():
		jumps_left = MAX_JUMPS
		can_dash = true
	# Saltar
	if Input.is_action_just_pressed("Jump") and jumps_left > 0:
>>>>>>> Stashed changes
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Movimiento lateral
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0 and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	# Dash
	if Input.is_action_just_pressed("Dash") and can_dash and direction != 0:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_direction = direction
		can_dash = false
		velocity.y = 0
		velocity.x = dash_direction * DASH_SPEED

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Animaciones
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")

	# Actualización de flip para la dirección del sprite
	animated_sprite.flip_h = not facing_right
	
	# Aplicar el movimiento
	move_and_slide()


func _on_timer_timeout():
	colision_flash.disabled = true
	sprite_2d.visible = false
	


func _on_cooldown_attack_timeout():
	can_attack = true
