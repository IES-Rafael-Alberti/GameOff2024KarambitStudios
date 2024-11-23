# GameManager.gd
extends Node

##--------------- Estadiscticas del jugador ------------------
var player_health = MAX_HEALTH
var score: int = 0
var flash_count: int = 3
const MAX_HEALTH = 3
 

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


func take_damage(amount: int) -> bool:
	player_health -= amount
	print("El jugador recibio " + str(amount) + " de daño")
	if player_health < 0:
		player_health = 0
	return true  # Retorna true si el daño fue aplicado correctamente
	
func rest_flash():
	if flash_count > 0:
		flash_count -= 1
		
func take_player_damage():
	print("Prueba")
	if player_health > 1:
		player_health -= 1
		print(player_health)
		if player_health <= 0:
			print("¡El jugador ha muerto!")
	elif player_health >= 0:
		print("Jugador eliminado")
		muerte()
		

func muerte():
	get_node("/root/Player").queue_free()
	# Recargar la escena
	get_tree().reload_current_scene()
	GameManager.player_health = GameManager.MAX_HEALTH
