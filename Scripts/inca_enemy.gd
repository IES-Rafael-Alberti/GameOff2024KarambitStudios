extends CharacterBody2D

# Variables de velocidad, vida y límites de movimiento
@export var speed: float = 40.0  # Velocidad del enemigo
@export var max_vida: int = 1  # Vida máxima del enemigo
@export var player_distance: float = 200.0
@export var terrain_distance: float = 10.0
@export var attack_damage: int = 10  # Daño que inflige el enemigo


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_inca = $AnimatedSprite2D
@onready var detection_player = $Detection_player  # Area2D para detectar al jugador
@onready var attack_collision = $AttackArea/AttackCollision  # Colisión de ataque

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var path_list: Array[Vector2] = []  # Lista de puntos del camino
var current_position: int = 0  # Índice del punto actual
var is_dead: bool = false  # Estado para manejar la muerte del enemigo
var jugador_detectado: bool = false  # Controla si el jugador está en el área

var vida: int

func _ready() -> void:
	# Inicializamos la vida del enemigo
	vida = max_vida
	# Añadimos al enemigo al grupo "enemigos"
	add_to_group("enemigos")
	
	# Desactivar el área de ataque al inicio
	

	# Verificar si los nodos existen antes de conectar señales
	if detection_player != null:
		detection_player.connect("body_entered", Callable(self, "_on_body_entered"))
		detection_player.connect("body_exited", Callable(self, "_on_body_exited"))
	else:
		print("Error: detection_player no está inicializado")

	if attack_collision != null:
		attack_collision.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
	else:
		print("Error: attack_collision no está inicializado")

	# Obtener la lista de puntos del camino
	var node_path_list = get_node("path").get_children()
	for node: Node2D in node_path_list:
		path_list.append(node.get_global_position())

# Método que se llama cuando algo entra en el área de detección del enemigo
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("El enemigo detectó al jugador")
		jugador_detectado = true
		
		mirar_jugador(body)

# Método que se llama cuando algo sale del área de detección del enemigo
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		print("El jugador salió del área del enemigo")
		jugador_detectado = false
		if attack_collision != null:
			attack_collision.disabled = true

# Función para hacer que el enemigo mire hacia el jugador
func mirar_jugador(jugador: Node) -> void:
	var posicion_jugador = jugador.global_position
	var direccion = posicion_jugador - global_position

	if direccion.x > 0:
		# El enemigo mira hacia la derecha
		sprite_inca.flip_h = false
		attack_collision.position.x = abs(attack_collision.position.x)  # Asegura que esté hacia la derecha
		attack_collision.scale.x = 1  # Restablece la escala
	elif direccion.x < 0:
		# El enemigo mira hacia la izquierda
		sprite_inca.flip_h = true
		attack_collision.position.x = -abs(attack_collision.position.x)  # Invierte la posición hacia la izquierda
		attack_collision.scale.x = -1  # Invierte la escala

# Lógica de movimiento
func _physics_process(delta: float) -> void:
	if is_dead or jugador_detectado:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	velocity.y += gravity * delta

	var current_point = path_list[current_position]
	var distance_to_point = get_global_position().distance_to(current_point)

	if distance_to_point > 5.0:
		if get_global_position().x < current_point.x:
			velocity.x = speed
			sprite_inca.flip_h = false
			attack_collision.position.x = abs(attack_collision.position.x)  # Hacia la derecha
			attack_collision.scale.x = 1
		else:
			velocity.x = -speed
			sprite_inca.flip_h = true
			attack_collision.position.x = -abs(attack_collision.position.x)  # Hacia la izquierda
			attack_collision.scale.x = -1
	else:
		current_position = (current_position + 1) % path_list.size()

	if velocity.x != 0:
		sprite_inca.play("walk")
	else:
		sprite_inca.play("idle")

	move_and_slide()

# Función de daño al enemigo
func take_damage(damage: int) -> void:
	vida -= damage
	print("Enemigo recibió daño, vida restante:", vida)
	if vida <= 0:
		die()

# Función para cuando el enemigo muere
func die() -> void:
	is_dead = true
	sprite_inca.play("muerto")
	sprite_inca.play("muerto_siempre")
	collision_shape_2d.set_deferred("disabled", true)
	attack_collision.disabled = false
	print("Enemigo muerto")

# Método que se llama cuando algo entra en el área de ataque
func _on_attack_area_body_entered(body: Node) -> void:
	print("Entro en la colision")
	if body.is_in_group("Player"):
		sprite_inca.play("attack")
		print("El enemigo golpeó al jugador")
		GameManager.take_player_damage()
