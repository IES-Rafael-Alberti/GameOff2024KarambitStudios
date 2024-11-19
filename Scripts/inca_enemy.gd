extends CharacterBody2D

# Variables de velocidad, vida y límites de movimiento
@export var speed: float = 40.0
@export var max_vida: int = 1  # Vida máxima del enemigo
@export var gravity: float = 200.0  # Gravedad aplicada al enemigo
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_inca = $AnimatedSprite2D
@onready var ray_cast_right = $RayCast/RayCastRight
@onready var ray_cast_left = $RayCast/RayCastLeft

# Dirección inicial del enemigo (1 para derecha, -1 para izquierda)
var direction: int = 1
var vida: int

func _ready() -> void:
	# Inicializamos la vida del enemigo
	vida = max_vida
	# Añadimos al enemigo al grupo "enemigos"
	add_to_group("enemigos")

func _physics_process(delta: float) -> void:
	# Aplicar gravedad al movimiento vertical
	velocity.y += gravity * delta

	# Detectar colisiones con el TileMap usando los RayCast2D
	if ray_cast_right.is_colliding() and direction == 1:
		# Cambia de dirección si el rayo derecho detecta una colisión
		cambiar_direccion()
	elif ray_cast_left.is_colliding() and direction == -1:
		# Cambia de dirección si el rayo izquierdo detecta una colisión
		cambiar_direccion()

	# Actualizar movimiento horizontal
	velocity.x = direction * speed

	# Actualizar animación
	sprite_inca.flip_h = direction == -1

	# Aplicar movimiento
	move_and_slide()

func cambiar_direccion() -> void:
	# Cambiar la dirección y mostrar un mensaje
	direction *= -1
	print("Cambio de dirección. Nueva dirección:", direction)

func recibir_dano(dano: int) -> void:
	# Reducir la vida del enemigo
	vida -= dano
	print("Enemigo recibió daño, vida restante:", vida)
	# Eliminar al enemigo si la vida llega a cero o menos
	if vida <= 0:
		eliminar()

func eliminar() -> void:
	# Función para eliminar el enemigo
	queue_free()
	print("Enemigo eliminado")
