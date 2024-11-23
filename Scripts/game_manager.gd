# GameManager.gd
extends Node

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

##--------- PowerUps activables ---------

var double_jump: bool = false
var dash: bool = false
var flashlight: bool = false

##--------- Variables escena 1 ---------
var player_position_puzzle: Vector2
var puzzle_1_complete = false
var puzzle_2_complete = false
var puzzle_3_complet = false

func apply_push_to_player(enemy_position: Vector2, player: CharacterBody2D) -> void:
	push_direction = player.position - enemy_position  # Dirección del empuje
	push_direction = push_direction.normalized()  # Normalizamos para mantener el empuje constante
	player.velocity = push_direction * push_force  # Aplicamos el empuje directamente al jugador
	print("Entra en la funcion del gamamanager")

func rest_flash():
	if flash_count > 0:
		flash_count -= 1

# Funcion para que el jugador reciba daño
func take_player_damage() -> void:
	print("Jugador recibe daño")
	if player_health > 0:
		player_health -= 1
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
