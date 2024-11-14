extends Node

# Vida máxima del jugador
const MAX_HEALTH = 3

# Vida actual del jugador
var player_health : int = MAX_HEALTH

# Estado de teletransportación
var teleport_activate : bool = false  # Variable para controlar si el teletransporte está activado
var teleport_destination : String = ""  # Esta es la propiedad que necesitas para almacenar el destino del teletransporte
var player_node: CharacterBody2D

# Función para reducir vida
func take_damage(amount: int = 1):
	current_health = max(current_health - amount, 0)
	print("Player took damage! Current health: ", current_health)

	# Verificar si la vida llega a 0
	if current_health <= 0:
		player_died()

# Función para gestionar la muerte del jugador
func player_died():
	print("Player has died!")
	# Lógica adicional como reiniciar el nivel o manejar el respawn puede añadirse aquí
