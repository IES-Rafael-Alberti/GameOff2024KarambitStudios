# GameManager.gd
extends Node

# Vida máxima del jugador
const MAX_HEALTH = 3
var player_health = MAX_HEALTH 

# Estado de teletransportación
var visible_e_key = false
var teleport_activate : bool = false  # Variable para controlar si el teletransporte está activado
var teleport_destination : String = ""  # Esta es la propiedad que necesitas para almacenar el destino del teletransporte
var player_node: CharacterBody2D


#---------Variables escena 1---------
var player_position_puzzle: Vector2
var puzzle_1_complete = false
