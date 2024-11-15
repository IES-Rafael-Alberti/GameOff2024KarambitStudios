extends CharacterBody2D

# Variables de velocidad, vida y límites de movimiento
@export var speed: float = 100.0
@export var left_limit: float = -200.0
@export var right_limit: float = 200.0
@export var max_vida: int = 1  # Vida máxima del enemigo


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Dirección inicial del enemigo (1 para derecha, -1 para izquierda)
var direction: int = 1
var vida: int

func _ready() -> void:
	# Inicializamos la vida del enemigo
	vida = max_vida
	# Añadimos al enemigo al grupo "enemigos"
	add_to_group("enemigos")

func _physics_process(delta: float) -> void:
	# Mover al enemigo
	velocity.x = direction * speed
	move_and_slide()

	# Cambiar de dirección si el enemigo llega a los límites
	if position.x <= left_limit:
		direction = 1  # Cambia la dirección hacia la derecha
	elif position.x >= right_limit:
		direction = -1  # Cambia la dirección hacia la izquierda

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
