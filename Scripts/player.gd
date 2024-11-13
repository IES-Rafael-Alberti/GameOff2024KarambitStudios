extends CharacterBody2D

# --------------- Constantes ------------------
const SPEED = 130.0 # Velocidad del personaje
const JUMP_VELOCITY = -300.0 # Velocidad del salto
const DASH_SPEED = 400.0 # Velocidad del dash
const DASH_DURATION = 1.5 # Duración del dash (segundos)
const MAX_JUMPS = 2 # Máximo de saltos
const ATTACK_DISTANCE = 30.0 # Distancia del área de ataque desde el personaje
const ATTACK_COOLDOWN = 0.5 # Cooldown del ataque (segundos)

#------------------- Variables ----------------
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var can_dash = true
var is_dashing = false
var can_attack = true

var actual_duplicate_time: float = 0
var duplicate_time: float = 0.05
var life_duplicate_time: float = 0.05

#---------------- Ajuste zoom camara ------------------
@export var camera_zoom = 2.5
@export var sprite_offset = Vector2(16,16)

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
@onready var attack_sprite: Sprite2D = $flashAttack/AttackSprite

@onready var cooldown_attack = $Timers/CooldownAttack
@onready var timer = $Timers/AttackTime
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var dash_cooldown: Timer = $Timers/DashCooldown

#------------------ Funciones -----------------
func _ready() -> void:
	# Inicializa el ataque en invisible
	pause_menu.visible = false
	attack_hitbox.visible = false
	attack_sprite.visible = false

func _physics_process(delta: float) -> void:
	# Detectamos la dirección del movimiento
	var direction = Input.get_axis("Move_left", "Move_right")

	actual_duplicate_time += delta

	# Actualizamos el flip del sprite según la dirección
	
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true


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

		
	#Dash mejorado
	if Input.is_action_just_pressed("Dash") and can_dash:
		is_dashing = true
		can_dash = false
		dash_timer.start()
		dash_cooldown.start()

	#Establece el estado de dash
	if direction:
		if is_dashing:
			velocity.y = 0		
			velocity.x = direction * DASH_SPEED
			if actual_duplicate_time >= duplicate_time:
				actual_duplicate_time = 0
				create_duplicate()
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
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
		var direction_multiplier = 1 if facing_right else -1

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
#Funcion para crear los duplicados en el dash
func create_duplicate():
	var duplicated = animated_sprite.duplicate(true)
	duplicated.material = animated_sprite.material.duplicate(true)
	duplicated.material.set_shader_parameter("Colors", Vector4(0.0,0.0,0.8,0.3))
	duplicated.material.set_shader_parameter("mix_color", 0.7)
	duplicated.position.y += position.y
	
	if animated_sprite.scale.x == -1:
		duplicated.position.x = position.x - duplicated.position.x
	else:
		duplicated.position.x += position.x
	
	duplicated.z_index -= 1
	get_parent().add_child(duplicated)
	await get_tree().create_timer(life_duplicate_time).timeout
	duplicated.queue_free()
	
# Funciones de tiempo de ataque
func _on_cooldown_attack_timeout():
	can_attack = true

#Timer para declarar cuando esta haciendo un dash
func _on_dash_timer_timeout() -> void:
	is_dashing = false
#Timer para declarar cuando puede volver a hacer un dash
func _on_dash_cooldown_timeout() -> void:
	can_dash = true
