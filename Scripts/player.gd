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

# --------------- Nodo UI y Teleport ------------------
@onready var pause_menu: Control = $UI/PauseMenu
@onready var e_key: Sprite2D = $Tecla

#------------------ Cargar escenas -----------------
@onready var animated_sprite = $PlayerSprite
@onready var state_machine = $State_Machine["parameters/playback"]

@onready var cooldown_attack = $CooldownAttack
@onready var timer = $AttackTime

#------------------ Funciones -----------------
func _ready() -> void:
	pause_menu.visible = false

func _physics_process(delta: float) -> void:
	# Detectamos la dirección del movimiento
	var direction = Input.get_axis("Move_left", "Move_right")

	# Verificamos el movimiento a la derecha e izquierda
	if direction > 0:
		facing_right = true
	elif direction < 0:
		facing_right = false

	# Actualizamos el flip del sprite según la dirección
	animated_sprite.flip_h = not facing_right

	# Movimiento del personaje
	if direction != 0 and not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	# Manejo de teletransportación
	if GameManager.teleport_activate == true:
		e_key.visible = true
	else:
		e_key.visible = false

	# Verifica la acción de pausa
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

	# Teletransportación
	if GameManager.teleport_activate == true and Input.is_action_just_pressed("Action"):
		teleport_to_scene(GameManager.teleport_destination)

	# Saltar (Aseguramos que no se salte mientras se está haciendo un dash)
	if Input.is_action_just_pressed("Jump") and jumps_left > 0 and not is_dashing:
		if jumps_left == MAX_JUMPS or not is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

	# Dash
	if Input.is_action_just_pressed("Dash") and can_dash and direction != 0:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_direction = direction
		can_dash = false
		velocity.y = 0
		velocity.x = dash_direction * DASH_SPEED

	# Aplicar gravedad si no está en el suelo y no está en dash
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta

	# Reiniciar saltos y dash si está en el suelo
	if is_on_floor() and velocity.y == 0:  # Solo reinicia si realmente está en el suelo y no se está moviendo verticalmente
		jumps_left = MAX_JUMPS
		can_dash = true

	# Aplicar el movimiento
	move_and_slide()

	# Actualizar animaciones
	if is_on_floor():
		if direction == 0:
			#animated_sprite.play("idle")
			state_machine.travel("idle")
		else:
			#animated_sprite.play("walk")
			state_machine.travel("walk")
	else:
		#animated_sprite.play("jump")
		print("salto")

	# Si está realizando un dash, temporizador
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Manejo de ataque
	if Input.is_action_just_pressed("flashAttack") and can_attack:
		timer.start()
		can_attack = false
		cooldown_attack.start()
		print(timer.time_left)
		print(cooldown_attack.time_left)

# Función para pausar/reanudar el juego
func toggle_pause():
	if pause_menu.visible:
		pause_menu.visible = false
		Engine.time_scale = 1.0
	else:
		pause_menu.visible = true
		Engine.time_scale = 0.0

# Función para teletransportar al jugador
func teleport_to_scene(scene: String):
	if GameManager.teleport_activate:
		get_node("/root/Player").queue_free()
		get_tree().change_scene_to_file("res://Scenes/" + scene + ".tscn")

# Funciones de tiempo de ataque
func _on_cooldown_attack_timeout():
	can_attack = true
