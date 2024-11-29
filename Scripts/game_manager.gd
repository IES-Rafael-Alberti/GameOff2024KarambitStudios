# GameManager.gd
extends Node
const PLAYER_DAMAGE = preload("res://Shaders/Player_damage.gdshader")
##--------------- Estadiscticas del jugador ------------------
var player_health = MAX_HEALTH
var score: int = 0
var save_score: int = 0
var kill_count: int = 0
var save_kill: int = 0
var coin_count: int = 0
var save_coin: int = 0
var gem_count: int = 0
var save_gem: int = 0
var flash_count: int = 5
const MAX_HEALTH = 5
var push_direction: Vector2 = Vector2.ZERO
var push_force: float = 500.0

##--------- Estado de teletransportación ------------
var visible_e_key = false
var teleport_activate : bool = false  # Variable para controlar si el teletransporte está activado
var teleport_destination : String = ""  # Esta es la propiedad que necesitas para almacenar el destino del teletransporte
var player_node: CharacterBody2D
var return_point: Vector2
##--------- PowerUps activables ---------

var double_jump: bool = false
var dash: bool = false
var flashlight: bool = false

##--------- Variables escena 1 ---------
var player_position_puzzle: Vector2
var puzzle_1_complete = false

var puzzle_2_complete = false
var returning_puzzle_2 = false

var puzzle_3_complete = false
var puzzle_3_position: Vector2 
func apply_push_to_player(enemy_position: Vector2, player: CharacterBody2D) -> void:
	push_direction = player.position - enemy_position  # Dirección del empuje
	push_direction = push_direction.normalized()  # Normalizamos para mantener el empuje constante
	player.velocity = push_direction * push_force  # Aplicamos el empuje directamente al jugador
	print("Entra en la funcion del gamamanager")

func rest_flash():
	if flash_count > 0:
		flash_count -= 1

# Funcion para que el jugador reciba daño
func take_player_damage(body: Node) -> void:
	print("Jugador recibe daño")
	if player_health > 0:
		player_health -= 1
		#Aplica el efecto de daño
		if body.name == "Player":
			body.can_take_damage = false
			body.i_frames.start()
			body.get_child(0).material.set_shader_parameter("mix_color", 0.7)
			body.damage_timer.start()

			# Retroceso al recibir daño
			#var knockback_force = 200  # Cambia según la intensidad del retroceso
			#var knockback_direction = (body.global_position - attacker_position).normalized()
			#body.velocity = knockback_direction * knockback_force
		print("Vida restante del jugador:", player_health)
		if player_health <= 0:
			print("¡El jugador ha muerto!")
			muerte()
	else:
		print("Jugador eliminado")
		muerte()
		

# Funcion la cual elimina al jugador cuando muere
func muerte():
	var player = get_node("/root/Player")
	player.is_dying = true
	player.state_machine_v2.travel("dead")
	player.dying_time.start()
	
