extends CharacterBody2D

# --------------- Constantes ------------------
const SPEED = 130.0 # Velocidad del personaje
const JUMP_VELOCITY = -300.0 # Velocidad del salto
const DASH_SPEED = 300.0 # Velocidad del dash
const DASH_DURATION = 0.2 # Duración del dash (segundos)
const DASH_COOLDOWN = 1.0 # Cooldown del dash (segundos)
const MAX_JUMPS = 2 # Máximo de saltos
const ATTACK_DISTANCE = 30.0 # Distancia del área de ataque desde el personaje
const ATTACK_COOLDOWN = 0.5 # Cooldown del ataque (segundos)

#------------------- Variables ----------------
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var can_dash = true  # Indica si el jugador puede hacer un dash
var is_dashing = false  # Indica si el jugador está en el dash
var dash_timer = 0.0  # Temporizador para la duración del dash
var dash_direction = 0.0  # Dirección del dash (izquierda/derecha)
var facing_right = true  # Dirección en la que está mirando el personaje
var can_attack = true  # Indica si el jugador puede atacar
var is_dash_cooldown_active = false # Sirve para controlar el dash

# Referencia al GameManager
@onready var game_manager = GameManager

# --------------- Nodo UI y Teleport ------------------
@onready var pause_menu: Control = $UI/PauseMenu
@onready var e_key: Sprite2D = $Tecla

#------------------ Cargar escenas -----------------
@onready var animated_sprite = $PlayerSprite
@onready var state_machine = $State_Machine["parameters/playback"]
@onready var cooldown_attack = $CooldownAttack
@onready var timer = $AttackTime
@onready var flash_attack: Area2D = $flashAttack
@onready var attack_hitbox: CollisionShape2D = $flashAttack/AttackHitbox
@onready var attack_sprite = $flashAttack/AttackSprite


#------------------ Funciones -----------------
func _ready() -> void:
	# Inicializa el ataque en invisible
	pause_menu.visible = false
	attack_hitbox.visible = false
	attack_sprite.visible = false

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
	e_key.visible = GameManager.teleport_activate

	# Verifica la acción de pausa
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

	# Teletransportación
	if GameManager.teleport_activate == true and Input.is_action_just_pressed("Action"):
		teleport_to_scene(GameManager.teleport_destination)

	# Saltar (No puede saltar mientras hace el dash)
	if Input.is_action_just_pressed("Jump") and jumps_left > 0 and not is_dashing:
		if jumps_left == MAX_JUMPS or not is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

	# Dash con cooldown
	if Input.is_action_just_pressed('Dash') and can_dash and direction != 0 and not is_dash_cooldown_active:
		# Iniciar el dash
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_direction = direction
		can_dash = false  # No puede hacer otro dash hasta que esta variable no se cambie
		is_dash_cooldown_active = true # Activa el cooldown del dash
		velocity.y = 0
		velocity.x = dash_direction * DASH_SPEED

		# Iniciar la duración del dash
		_start_dash_duration()
		
		var limits = get_viewport_rect().size * 0.5 - Vector2(128, 128) * 0.5 
		position.x = clamp(position.x, -limits.x, limits.x)
		position.y = clamp(position.y, -limits.y, limits.y)

	# Aplicar gravedad si no está en el suelo y no está en dash
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta

	# Reiniciar saltos si está en el suelo
	if is_on_floor() and velocity.y == 0:
		jumps_left = MAX_JUMPS

	# Realizar el ataque si se presiona el botón derecho del ratón
	if Input.is_action_just_pressed("flashAttack") and can_attack:
		perform_attack()

	# Actualizar animaciones
	if is_on_floor():
		if direction == 0:
			velocity.x = 0
			state_machine.travel("idle")
		else:
			state_machine.travel("walk")
	else:
		if velocity.y < 0:
			state_machine.travel("jump_up")
		if velocity.y > 0:
			state_machine.travel("jump_down")

	# Si está realizando un dash, temporizador
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			# Iniciar cooldown del dash
			_start_dash_cooldown()

	# Aplicar el movimiento al final
	move_and_slide()

# ----------------- Función para realizar el ataque -------------------
func perform_attack():
	if can_attack:
		can_attack = false
		attack_hitbox.visible = true
		attack_sprite.visible = true

		# Calcula la dirección multiplicadora basado en si el personaje mira a la derecha o a la izquierda
		var direction_multiplier = 0.2 if facing_right else -0.2

		# Posicionamos el ataque en relación con la posición actual del personaje
		var attack_position = position + Vector2(ATTACK_DISTANCE * direction_multiplier, 0)

		# Alineamos la posición del ataque respecto al personaje
		attack_hitbox.global_position = attack_position
		attack_sprite.global_position = attack_position

		# Ajustamos la escala del sprite para orientar el ataque
		attack_sprite.scale.x = direction_multiplier

		# Desactiva el ataque después de un breve periodo
		await get_tree().create_timer(0.5).timeout
		attack_hitbox.visible = false
		attack_sprite.visible = false
		_start_attack_cooldown()


# Función para iniciar el cooldown del ataque
func _start_attack_cooldown():
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true

# Función para iniciar la duración del dash
func _start_dash_duration():
	# El dash tiene una duración de tiempo antes de iniciar el cooldown
	await get_tree().create_timer(DASH_DURATION).timeout
	# Cuando el dash termine, se puede iniciar el cooldown
	_start_dash_cooldown()

# Función para iniciar el cooldown del dash
func _start_dash_cooldown():
	# Espera el tiempo de cooldown antes de permitir otro dash
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true
	is_dash_cooldown_active = false  # Resetea el cooldown del dash, permitiendo el siguiente dash

# --------------------- Funciones menú ---------------------
# Función para pausar/reanudar el juego
func toggle_pause():
	if pause_menu.visible:
		pause_menu.visible = false
		Engine.time_scale = 1.0
	else:
		pause_menu.visible = true
		Engine.time_scale = 0.0

# ----------------- Función de teletransporte -------------------
# Función para teletransportar al jugador
func teleport_to_scene(scene: String):
	if GameManager.teleport_activate:
		get_node("/root/Player").queue_free()
		get_tree().change_scene_to_file("res://Scenes/" + scene + ".tscn")

# ------------------ Función de daño ---------------------
# Llamamos al método de GameManager para reducir vida
func take_damage(amount: int = 1):
	if game_manager:
		game_manager.take_damage(amount)
