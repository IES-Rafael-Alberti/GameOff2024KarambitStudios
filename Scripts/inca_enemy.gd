extends CharacterBody2D

# Variables de velocidad, vida y límites de movimiento
@export var speed: float = 40.0  # Velocidad del enemigo
@export var max_vida: int = 1  # Vida máxima del enemigo
@export var player_distance: float = 200.0
@export var terrain_distance: float = 10.0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_inca = $AnimatedSprite2D
@onready var area = $Area2D  # Area2D para detectar al jugador

var path_list: Array[Vector2] = []  # Lista de puntos del camino
var current_position: int = 0  # Índice del punto actual
var is_dead: bool = false  # Estado para manejar la muerte del enemigo

var target = null
signal new_target(_target)

var vida: int

func _ready() -> void:
	# Inicializamos la vida del enemigo
	vida = max_vida
	# Añadimos al enemigo al grupo "enemigos"
	add_to_group("enemigos")

	# Conectamos la señal de "body_entered" para detectar cuando el jugador entra en el área
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Obtener la lista de puntos del camino
	var node_path_list = get_node("path").get_children()
	for node: Node2D in node_path_list:
		path_list.append(node.get_global_position())

# Método que se llama cuando algo entra en el área del enemigo
func _on_body_entered(body: Node) -> void:
	# Verificamos si el cuerpo que entra es un jugador
	if body.is_in_group("Player"):
		print("El enemigo detectó al jugador")
		# Llamamos al método para que el enemigo mire hacia el jugador
		mirar_jugador(body)

# Función para hacer que el enemigo mire hacia el jugador
func mirar_jugador(jugador: Node) -> void:
	# Obtener la posición global del jugador
	var posicion_jugador = jugador.global_position
	var direccion = posicion_jugador - global_position  # Calculamos la dirección hacia el jugador

	# Verificar si el jugador está a la derecha o a la izquierda
	if direccion.x > 0:
		sprite_inca.flip_h = false  # Mirar hacia la derecha
	elif direccion.x < 0:
		sprite_inca.flip_h = true  # Mirar hacia la izquierda

# Lógica de movimiento (puedes mantenerla como estaba en tu código)
func _physics_process(delta: float) -> void:
	# Si el enemigo está muerto, detén cualquier lógica de movimiento
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Animaciones basadas en movimiento
	if velocity.x != 0:
		sprite_inca.play("walk")
	else:
		sprite_inca.play("idle")
	
	# Obtener posición actual y objetivo
	var current_point = path_list[current_position]
	var distance_to_point = get_global_position().distance_to(current_point)

	# Mover hacia el punto objetivo
	if distance_to_point > 5.0:  # Umbral para considerar "alcanzado"
		if get_global_position().x < current_point.x:
			velocity.x = speed
			sprite_inca.flip_h = false  # Mirar a la derecha
		else:
			velocity.x = -speed
			sprite_inca.flip_h = true  # Mirar a la izquierda
	else:
		# Cambiar al siguiente punto del camino
		current_position = (current_position + 1) % path_list.size()

	# Mover al enemigo
	move_and_slide()

# Función de daño al enemigo
func recibir_dano(dano: int) -> void:
	# Reducir la vida del enemigo
	vida -= dano
	print("Enemigo recibió daño, vida restante:", vida)
	# Eliminar al enemigo si la vida llega a cero o menos
	if vida <= 0:
		morir()

# Función para cuando el enemigo muere
func morir() -> void:
	# Cambiar estado a muerto
	is_dead = true

	# Reproducir animación de "muerto"
	sprite_inca.play("muerto")
	sprite_inca.play("muerto_siempre")
	# Detener colisiones
	collision_shape_2d.set_deferred("disabled", true)

	# Imprimir mensaje para depuración
	print("Enemigo muerto, animación reproducida")
