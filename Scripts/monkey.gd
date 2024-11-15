extends CharacterBody2D

var can_attack = true

# Exporta para ajustar la fuerza del lanzamiento
@export var throw_power: float = 300.0

@onready var sprite_monkey: AnimatedSprite2D = $SpriteMonkey
@onready var shooting_point: Node2D = $ShootingPoint

@onready var attack_cooldown: Timer = $AttackCooldown
@onready var stone_spawn_time: Timer = $StoneSpawnTime

const MONKEY_STONE = preload("res://Scenes/monkey_stone.tscn")



func _process(delta: float) -> void:
	if GameManager.player_node:

		if (GameManager.player_node.global_position - sprite_monkey.global_position).length() < 200:  # Ajusta el rango
			if can_attack:
				throw_stone()
	else:
		print("NO hay jugador: " + str(GameManager.player_node))
		
func throw_stone():
	# Asegúrate de que el jugador existe antes de lanzar
	if not GameManager.player_node:
		return

	# Calcula la dirección hacia el jugador
	var direction = (GameManager.player_node.global_position - shooting_point.global_position).normalized()

	# Instancia una nueva piedra
	var stone = MONKEY_STONE.instantiate() as RigidBody2D
	get_parent().add_child(stone)
	stone.freeze = true
	stone_spawn_time.start()
	can_attack = false
	attack_cooldown.start()
	# Coloca la piedra en la posición del mono
	stone.global_position = shooting_point.global_position

	# Aplica una fuerza en la dirección del jugador
	await  stone_spawn_time.timeout
	stone.freeze = false
	stone.apply_impulse(direction * throw_power, shooting_point.global_position)


func _on_attack_cooldown_timeout() -> void:
	can_attack = true


#func _on_stone_spawn_time_timeout() -> void:
	#stone.freeze = false
	