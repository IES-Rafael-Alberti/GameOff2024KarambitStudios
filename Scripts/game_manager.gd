extends Node

# Vida máxima del jugador
const MAX_HEALTH = 3

# Vida actual del jugador
var player_health : int = MAX_HEALTH

# Estado de teletransportación
var teleport_activate : bool = false  # Variable para controlar si el teletransporte está activado
var teleport_destination : String = ""  # Esta es la propiedad que necesitas para almacenar el destino del teletransporte
