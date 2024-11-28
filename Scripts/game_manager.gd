# GameManager.gd
extends Node
const PLAYER_DAMAGE = preload("res://Shaders/Player_damage.gdshader")
##--------------- Estadiscticas del jugador ------------------
var player_health = MAX_HEALTH
var score: int = 0
var flash_count: int = 3
const MAX_HEALTH = 3
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
var dash: bool = true
var flashlight: bool = false

##--------- Variables escena 1 ---------
var player_position_puzzle: Vector2
var puzzle_1_complete = false
var occupied_positions_puzle_1: Array[Vector2] = []

var puzzle_2_complete = false
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
		body.can_take_damage = false
		body.i_frames.start()
		body.get_child(0).material.set_shader_parameter("mix_color",0.7)
		body.damage_timer.start()
		print("Vida restante del jugador:", player_health)
		if player_health <= 0:
			print("¡El jugador ha muerto!")
			muerte()
	else:
		print("Jugador eliminado")
		muerte()
		

# Funcion la cual elimina al jugador cuando muere
func muerte():
	get_node("/root/Player").queue_free()
	# Recargar la escena
	get_tree().reload_current_scene()
	GameManager.player_health = GameManager.MAX_HEALTH
