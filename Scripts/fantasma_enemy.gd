extends CharacterBody2D

# Variables
@export var speed: float = 150.0  # Velocidad del fantasma
@export var vida: int = 100  # Vida inicial del fantasma
var player: Node2D = null  # Referencia al jugador
var is_chasing: bool = false  # Estado del fantasma

# Referencias
@onready var detection_player: Area2D = $Detection_player
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Referencia al sprite animado

func _ready():
	# Conectar las señales del área de detección usando Callable
	detection_player.body_entered.connect(_on_body_entered)
	detection_player.body_exited.connect(_on_body_exited)

func _physics_process(delta: float):
	if is_chasing and player:
		# Calcular la dirección hacia el jugador
		var direction = (player.global_position - global_position).normalized()
		# Aplicar velocidad hacia el jugador
		velocity = direction * speed

		# Flip horizontal según la dirección
		if direction.x < 0:
			sprite.flip_h = true  # Voltear hacia la izquierda
		elif direction.x > 0:
			sprite.flip_h = false  # Voltear hacia la derecha
	else:
		# Detener al fantasma si no está persiguiendo
		velocity = Vector2.ZERO

	# Aplicar movimiento
	move_and_slide()

func recibir_dano(damage: int) -> void:
	# Reducir vida del fantasma
	vida -= damage
	print("Fantasma recibió daño, vida restante:", vida)
	if vida <= 0:
		die()

# Función para cuando el fantasma muere
func die() -> void:
	# Desactiva las colisiones para evitar interacciones
	collision_shape.set_deferred("disabled", true)
	detection_player.set_deferred("disabled", true)
	print("Fantasma eliminado")
	# Eliminar el nodo del fantasma
	queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("Player"): 
		player = body
		is_chasing = true

func _on_body_exited(body: Node):
	if body == player:
		player = null
		is_chasing = false
