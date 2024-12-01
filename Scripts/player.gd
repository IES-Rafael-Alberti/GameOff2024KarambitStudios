extends CharacterBody2D

## --------------- Constantes ------------------
const SPEED = 130.0 # Velocidad del personaje
const JUMP_VELOCITY = -300.0 # Velocidad del salto
const DASH_SPEED = 400.0 # Velocidad del dash
const DASH_DURATION = 1.5 # Duración del dash (segundos)

const DASH_EFFECT_SHADER = preload("res://Shaders/DashEffectShader.gdshader")
const DAMAGE_SHADER = preload("res://Shaders/DamageShader.gdshader")
const PLAYER_DAMAGE = preload("res://Shaders/Player_damage.gdshader")
## ------------------- Variables ----------------
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var MAX_JUMPS = 1
var jumps_left = MAX_JUMPS
var actual_duplicate_time: float = 0
var duplicate_time: float = 0.1
var life_duplicate_time: float = 0.1
## -------------- Variables de permiso ---------------------
var can_attack = true
var can_dash = GameManager.dash
var can_flash = GameManager.flash_count > 0
var can_take_damage = true
## --------------- Variables de estado -----------------
var facing_right = true
var is_dashing = false
var is_sinking: bool = false
var is_falling: bool = false
var is_attacking: bool = false
var is_flashing: bool = false
var is_dying: bool = false
var is_looking_down: bool = false
##---------------- Sonidos -----------------
@onready var hit_sound: AudioStreamPlayer = $Sounds/HitSound
@onready var jump_sound: AudioStreamPlayer = $Sounds/JumpSound
@onready var dash_sound: AudioStreamPlayer = $Sounds/DashSound
@onready var flash_sound: AudioStreamPlayer = $Sounds/FlashSound
@onready var collectable_sound: AudioStreamPlayer = $Sounds/CollectableSound

## --------------- Secret Code ------------------
var secret_code = ["Move_left", "Move_right","Move_left", "Move_right", "flashAttack", "meleeAttack", "Jump"]

var current_index = 0
## --------------- Nodo UI y Teleport ------------------
@onready var pause_menu: Control = $UI/PauseMenu
@onready var e_key: Sprite2D = $Tecla
@onready var hud: Control = $UI/HUD
@onready var camara_player: Camera2D = $CamaraPlayer
@onready var death_animation_player: AnimationPlayer = $CamaraPlayer/DeathAnimationPlayer
@onready var score_animations: AnimationPlayer = $UI/Scoreboard/Score_animations

## ------------------ Cargar escenas -----------------
@onready var animated_sprite = $PlayerSprite
@onready var state_machine_v2 = $StateMachine["parameters/playback"]
@onready var animation_player: AnimationPlayer = $AnimationPlayer


## ------------------ Timers -----------------
@onready var attack_timer = $Timers/AttackTimer
@onready var attack_cool_down = $Timers/AttackCoolDown
@onready var i_frames: Timer = $Timers/iFrames
@onready var damage_timer: Timer = $Timers/DamageTimer
@onready var dying_time: Timer = $Timers/DyingTime


## --------------- Variables Ataque linterna ----------------------

@onready var flash_attack_right: Area2D = $flashAttackRight
@onready var flash_hitbox_right: CollisionShape2D = $flashAttackRight/FlashHitboxRight
@onready var flash_attack_left: Area2D = $flashAttackLeft
@onready var flash_hitbox_left: CollisionShape2D = $flashAttackLeft/FlashHitboxLeft


## -------------- Variables Ataque melee -------------
@onready var melee_attack_right: Area2D = $meleeAttackRight
@onready var attack_hitbox_right: CollisionShape2D = $meleeAttackRight/AttackHitboxRight
@onready var melee_attack_left: Area2D = $meleeAttackLeft
@onready var attack_hitbox_left: CollisionShape2D = $meleeAttackLeft/AttackHitboxLeft


## ------------- Variables Timers ---------------
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var dash_cooldown: Timer = $Timers/DashCooldown
@onready var player_sensor: Area2D = $PlayerSensor


## ------------------ Funciones -----------------
func _ready() -> void:
	# Inicializa el ataque en invisible
	pause_menu.visible = false
	
	animated_sprite.material.set_shader_parameter("mix_color", 0.0)
	if GameManager.double_jump:
		MAX_JUMPS = 2
	
	if not scene_file_path.contains("museum_scene"):
		camara_player.visible = true
		camara_player.get_child(0).visible = true
		hud.visible = true
	else:
		camara_player.visible = false
		camara_player.get_child(0).visible = false
	if GameManager.game_complete:
		score_animations.play("score_animation")
func _physics_process(delta: float) -> void:
	
	
	SecretCode()
	# Detectamos la dirección del movimiento
	var direction = Input.get_axis("Move_left", "Move_right")
	actual_duplicate_time += delta
	# Actualizamos el flip del sprite según la dirección
	
	if direction > 0:
		animated_sprite.flip_h = false
		facing_right = true
	if direction < 0:
		animated_sprite.flip_h = true
		facing_right = false


	# Manejo de teletransportación
	e_key.visible = GameManager.visible_e_key

	if Input.is_action_just_pressed("Look_down") and not is_attacking and not is_dashing and not is_dying and not is_falling and not is_flashing and not is_sinking:
		is_looking_down = true
		state_machine_v2.travel("look_down")
	if Input.is_action_just_released("Look_down") and is_looking_down:
		is_looking_down = false
	# Verifica la acción de pausa
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()
		
	# Teletransportación
	if GameManager.teleport_activate == true and Input.is_action_just_pressed("Action"):
		teleport_to_scene(GameManager.teleport_destination)

	# Saltar (No puede saltar mientras hace el dash)
	if Input.is_action_just_pressed("Jump") and jumps_left > 0 and not is_dashing and not is_dying:
		if jumps_left == MAX_JUMPS or not is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
			jump_sound.play()

		
	#Dash mejorado
	if Input.is_action_just_pressed("Dash") and can_dash:
		state_machine_v2.travel("dash")
		dash_sound.play()
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
			animated_sprite.material.shader = DAMAGE_SHADER
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	# Aplicar gravedad si no está en el suelo y no está en dash
	if not is_on_floor() and not is_dashing and not is_sinking:
		velocity.y += gravity * delta
		
		
	if not is_on_floor():
		is_falling = true
	else:
		is_falling = false

	if is_sinking and is_falling:
		
		print("Se hunde")
		jumps_left = 0
		velocity = Vector2(0,gravity * delta)
		print("Velocity: ", velocity)

	# Reiniciar saltos si está en el suelo
	if is_on_floor() and velocity.y == 0 and not is_sinking:
		jumps_left = MAX_JUMPS

	# Realizar el ataque si se presiona el botón derecho del ratón
	if Input.is_action_just_pressed("flashAttack") and not is_dying:
		print("Ataque linterna")
		state_machine_v2.travel("attack_flashlight")
		perform_attack_flashlight()
	elif Input.is_action_just_pressed("meleeAttack") and not is_dying:
		print("Ataque melee")
		#state_machine_v2.travel("attack_shovel")
		state_machine_v2.travel("attack_shovel")
		perform_attack_melee()

	# Actualizar animaciones
	if is_on_floor() and not is_attacking and not is_flashing and not is_dying and not is_looking_down:
		if direction == 0:
			velocity.x = 0 
			state_machine_v2.travel("idle")
		else:
			state_machine_v2.travel("walk")
	else:
		if velocity.y < 0 and not is_dying and not is_attacking and not is_flashing and not is_looking_down:
			state_machine_v2.travel("jump_up")
		if velocity.y > 0 and not is_dying and not is_attacking and not is_flashing and not is_looking_down:
			state_machine_v2.travel("jump_down")
			
	if is_dying:
		velocity.x = 0
	# Aplicar el movimiento al final
	move_and_slide()
	
	## ----------------- Función para realizar el ataque a melee -------------------
func perform_attack_melee():
	if can_attack:
		can_attack = false
		is_attacking = true
		hit_sound.play()
		if facing_right:
			attack_hitbox_right.disabled = false
		elif not facing_right:
			attack_hitbox_left.disabled = false
		
		attack_timer.start()
		attack_cool_down.start()

## ----------------- Función para realizar el ataque de la literna -------------------
func perform_attack_flashlight():
	if can_attack and GameManager.flash_count > 0 and GameManager.flashlight:
		can_attack = false
		is_flashing = true
		flash_sound.play()
		if facing_right:
			flash_attack_right.visible = true
			flash_hitbox_right.disabled = false
		elif not facing_right:
			flash_attack_left.visible = true
			flash_hitbox_left.disabled = false
			

		GameManager.rest_flash()
		## Desactiva el ataque después de un breve periodo
		attack_timer.start()
		attack_cool_down.start()
func damage_zone(body: Node):
	print("Colisión detectada con:", body)
	# Verifica si el objeto que entró en el área es un enemigo
	if body.is_in_group("enemigos"):
		print("Enemigo detectado en el área de ataque")
		body.recibir_dano(1)
		GameManager.score += 10
		GameManager.kill_count += 1
# --------------- Colision del flashAttack --------------------
func _on_flash_attack_body_entered(body: Node) -> void:
	damage_zone(body)
		
## -------------- Colision del meleeAttack
func _on_melee_attack_body_entered(body: Node2D) -> void:
	damage_zone(body)

# --------------------- Funciones menú ---------------------
# Función para pausar/reanudar el juego 
func toggle_pause():
	if pause_menu.visible:
		hud.visible = true
		pause_menu.visible = false
		Engine.time_scale = 1.0
	else:
		hud.visible = false
		pause_menu.visible = true
		Engine.time_scale = 0.0
	
## ----------------- Función de teletransporte -------------------
# Función para teletransportar al jugador
func teleport_to_scene(scene: String):
	if GameManager.teleport_activate:
		get_node("/root/Player").queue_free()
		get_tree().change_scene_to_file("res://Scenes/Levels/" + scene + ".tscn")
#Funcion para crear los duplicados en el dash
func create_duplicate():
	animated_sprite.material.shader = DASH_EFFECT_SHADER
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
	
## ------------------ Nodos ---------------------------
#Timer para declarar cuando esta haciendo un dash
func _on_dash_timer_timeout() -> void:
	is_dashing = false

#Tiempo en atacar de nuevo
func _on_attack_cool_down_timeout():
	can_attack = true

# Tiempo de ataque
func _on_attack_timer_timeout():
	pass
	if is_attacking:
		attack_hitbox_right.disabled = true
		attack_hitbox_left.disabled = true
		is_attacking = false	
	elif is_flashing:
		flash_attack_right.visible = false
		flash_hitbox_right.disabled = true
		flash_attack_left.visible = false
		flash_hitbox_left.disabled = true
		is_flashing = false
#Tiempo para volver a hacer un dash
func _on_dash_cooldown_timeout():
	can_dash = true


func _on_player_sensor_body_entered(body: Node2D) -> void:
	if can_take_damage:
		if body.is_in_group("enemigos") or body.is_in_group("proyectile"):
			# Llamamos al GameManager para aplicar el empuje
			GameManager.apply_push_to_player(body.position, self)
			
			# Luego aplicamos el daño
			GameManager.take_player_damage(self)
			#Aplica el efecto de daño
			$PlayerSprite.material.set_shader_parameter("mix_color", 0.7)
			damage_timer.start()
			# Iniciamos el temporizador de i-frames
			can_take_damage = false
			i_frames.start()

func _on_i_frames_timeout() -> void:
	can_take_damage = true


func _on_damage_timer_timeout() -> void:
	$PlayerSprite.material.set_shader_parameter("mix_color", 0.0)


func _on_dying_time_timeout() -> void:
	queue_free()
	is_dying = false
	get_tree().reload_current_scene()

func get_look_direction() -> Vector2:
	return Vector2.RIGHT if animated_sprite.flip_h == false else Vector2.LEFT
	
func flash_attack() -> bool:
	return is_flashing

func _on_score_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "score_animation":
		get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
		queue_free()
		GameManager.score = 0
		GameManager.save_score = 0
		GameManager.kill_count = 0
		GameManager.save_kill = 0
		GameManager.coin_count = 0
		GameManager.save_coin = 0
		GameManager.gem_count = 0
		GameManager.save_gem = 0
		GameManager.puzzle_1_complete = false
		GameManager.puzzle_2_complete = false
		GameManager.puzzle_3_complete = false
		GameManager.game_complete = false
		GameManager.dash = false
		GameManager.double_jump = false
		GameManager.flashlight = false


func SecretCode() -> void:
	for action in secret_code:
		if Input.is_action_just_pressed(action):
			print(action)
			# Verifica si la acción corresponde al índice actual de la secuencia
			if action == secret_code[current_index]:
				current_index += 1  # Avanza al siguiente paso del código
				if current_index == secret_code.size():
					_on_code_entered()  # Código completo ingresado
					current_index = 0  # Reinicia para nuevos intentos
			else:
				# Reinicia si la acción no coincide con la secuencia esperada
				current_index = 0
			break  # Sal del bucle para evitar procesar múltiples acciones al mismo tiempo

				
func _on_code_entered():
	print("¡Código secreto activado!")
	if GameManager.player_health < GameManager.MAX_HEALTH:
		GameManager.player_health += 1
