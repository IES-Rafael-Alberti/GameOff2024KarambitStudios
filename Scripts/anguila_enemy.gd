extends CharacterBody2D

@export var speed: float = 40.0  # Velocidad del enemigo
@export var max_vida: int = 1  # Vida máxima del enemigo
@export var attack_damage: int = 1  # Daño que inflige el enemigo

@onready var colision_detection: CollisionShape2D = $AreaDetection/ColisionDetection

@onready var sprite_anguila = $AnimatedSprite2D

var path_list: Array[Vector2] = []  # Lista de puntos del camino
var current_position: int = 0  # Índice del punto actual
var is_dead: bool = false  # Estado para manejar la muerte del enemigo

var vida: int
var direction: int = 1  # Dirección actual del enemigo (-1: izquierda, 1: derecha)

func _ready() -> void:
	vida = max_vida
	add_to_group("enemigos")

	# Obtener la lista de puntos del camino
	var node_path_list = get_node("path").get_children()
	for node: Node2D in node_path_list:
		path_list.append(node.get_global_position())

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if path_list.size() == 0:
		return  # No hay puntos en el camino, no hacer nada

	# Obtener el punto actual y el siguiente
	var target_point = path_list[current_position]
	var current_pos = get_global_position()

	# Calcular la dirección y velocidad hacia el punto objetivo
	velocity = (target_point - current_pos).normalized() * speed

	if current_pos.distance_to(target_point) <= 5.0:  # Si ha llegado al punto
		current_position = (current_position + 1) % path_list.size()
		velocity = Vector2.ZERO  # Detener el movimiento

	# Mover usando move_and_slide
	move_and_slide()

	# Procesar colisiones detectadas
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()  # Objeto con el que colisionaste

		

	# Actualizar flip dependiendo de la dirección del movimiento
	var new_direction = 1 if velocity.x > 0 else -1
	if new_direction != direction:
		direction = new_direction
		sprite_anguila.flip_h = direction == -1

	# Controlar la animación
	if velocity.length() > 0 and not sprite_anguila.is_playing():
		sprite_anguila.play("walk")
	elif velocity.length() == 0:
		sprite_anguila.stop()

func _on_area_detection_body_entered(body: Node2D) -> void:
	print("Entro")
	if body.is_in_group("Player"):  # Si el collider es el jugador
			GameManager.take_player_damage(body)
