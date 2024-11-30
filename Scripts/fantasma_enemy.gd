extends CharacterBody2D

# Variables
@export var speed: float = 150.0  # Velocidad del fantasma
@export var vida: int = 1  # Vida inicial del fantasma
var player: Node2D = null  # Referencia al jugador
var is_chasing: bool = false  # Estado del fantasma

# Referencias
@onready var detection_player: Area2D = $Detection_player
@onready var collision_fantasma = $CollisionFantasma
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Referencia al sprite animado

func _ready():
	add_to_group("enemigos")
	# Conectar las señales del área de detección
	detection_player.body_entered.connect(_on_body_entered)
	detection_player.body_exited.connect(_on_body_exited)

func _physics_process(delta: float):
	if vida >= 1:
		if is_chasing and player:
			# Calcular dirección hacia el jugador
			var direction = (player.global_position - global_position).normalized()

			# Verificar si el jugador está mirando hacia el fantasma
			if _player_is_looking_at_me(direction):
				# Moverse hacia el jugador solo si no está siendo mirado
				sprite.play("walk")
				velocity = direction * speed

				# Flip horizontal según la dirección
				if direction.x < 0:
					sprite.flip_h = true  # Voltear hacia la izquierda
				elif direction.x > 0:
					sprite.flip_h = false  # Voltear hacia la derecha
			else:
				# Detener movimiento si está siendo mirado
				sprite.play("idle")
				velocity = Vector2.ZERO
		else:
			# Detener al fantasma si no está persiguiendo
			sprite.play("idle")
			velocity = Vector2.ZERO

		# Aplicar movimiento
		move_and_slide()
	else:
		return
	

func _player_is_looking_at_me(direction_to_me: Vector2) -> bool:
	if player.has_method("get_look_direction"):
		var look_direction = player.get_look_direction()
		return direction_to_me.dot(look_direction) > 0
	return false

func recibir_dano(damage: int) -> void:
	# Reducir vida del fantasma
	if player.has_method("flash_attack"):
		var player_is_flashing = player.flash_attack()
		if player_is_flashing:
			vida -= damage
			print("Fantasma recibió daño, vida restante:", vida)
			if vida <= 0:
				die()

# Función para cuando el fantasma muere
func die() -> void:
	sprite.play("muerto")
	sprite.play("muerto_siempre")
	# Desactiva las colisiones para evitar interacciones
	collision_fantasma.set_deferred("disabled", true)
	detection_player.set_deferred("disabled", true)
	print("Fantasma eliminado")

func _on_body_entered(body: Node):
	if body.is_in_group("Player"): 
		player = body
		is_chasing = true

func _on_body_exited(body: Node):
	if body == player:
		player = null
		is_chasing = false
