# GameManager.gd
extends Node

# Vida máxima del jugador
const MAX_HEALTH = 3
var player_health = MAX_HEALTH

# Estado de teletransportación
var teleport_activate : bool = false  # Variable para controlar si el teletransporte está activado
var teleport_destination : String = ""  # Esta es la propiedad que necesitas para almacenar el destino del teletransporte
var player_node: CharacterBody2D


#---------Variables escena 1---------
var player_position_puzzle
var puzzle_1_complete = false



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
