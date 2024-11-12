extends CharacterBody2D

# --------------- Constantes ------------------
const SPEED = 130.0 # Velocidad del personaje
const JUMP_VELOCITY = -300.0 # Velocidad del salto
const DASH_SPEED = 400.0 # Velocidad del dash
const DASH_DURATION = 1.5 # Duración del dash (segundos)
const MAX_JUMPS = 2 # Máximo de saltos

#------------------- Variables ----------------
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var can_dash = true
var is_dashing = false
var can_attack = true

var actual_duplicate_time: float = 0
var duplicate_time: float = 0.05
var life_duplicate_time: float = 0.05

# --------------- Nodo UI y Teleport ------------------
@onready var pause_menu: Control = $UI/PauseMenu
@onready var e_key: Sprite2D = $Tecla

#------------------ Cargar escenas -----------------
@onready var animated_sprite = $PlayerSprite
@onready var state_machine = $State_Machine["parameters/playback"]

@onready var cooldown_attack = $Timers/CooldownAttack
@onready var timer = $Timers/AttackTime
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var dash_cooldown: Timer = $Timers/DashCooldown

#------------------ Funciones -----------------
func _ready() -> void:
	pause_menu.visible = false

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

	# Reiniciar saltos y dash si está en el suelo
	if is_on_floor() and velocity.y == 0:  # Solo reinicia si realmente está en el suelo y no se está moviendo verticalmente
		jumps_left = MAX_JUMPS

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
		pass


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
