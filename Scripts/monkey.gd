extends CharacterBody2D

# Exporta para ajustar la fuerza del lanzamiento
@export var throw_power: float = 500.0
@export var stone_scene: PackedScene  # Escena de la piedra

# Nodo del jugador
var player: Node2D

func _ready():
	# Obtén el nodo del jugador en la escena
	player = get_parent().get_node("Player")  # Ajusta la ruta si el jugador está en otro lugar

func _process(delta: float) -> void:
	if (player.global_position - global_position).length() < 200:  # Ajusta el rango
		throw_stone()

func throw_stone():
	# Asegúrate de que el jugador existe antes de lanzar
	if not player:
		return

	# Calcula la dirección hacia el jugador
	var direction = (player.global_position - global_position).normalized()

	# Instancia una nueva piedra
	var stone = stone_scene.instantiate() as RigidBody2D
	get_parent().add_child(stone)

	# Coloca la piedra en la posición del mono
	stone.global_position = global_position

	# Aplica una fuerza en la dirección del jugador
	stone.apply_impulse(Vector2.ZERO, direction * throw_power)
