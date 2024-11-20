extends CharacterBody2D

# Variables de velocidad, vida y límites de movimiento
@export var speed: float = 40.0
@export var max_vida: int = 1  # Vida máxima del enemigo
@export var player_distance: float = 200.0
@export var terrain_distance: float = 10.0
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_inca = $AnimatedSprite2D
@onready var raycast_player = $RayCast/RayCastPlayer
@onready var raycast_terrain = $RayCast/RayCastTerrain


var path_list: Array[Vector2]
var current_position: int = 0

var target = null
signal new_target(_target)

var vida: int

func _ready() -> void:
	# Inicializamos la vida del enemigo
	vida = max_vida
	# Añadimos al enemigo al grupo "enemigos"
	add_to_group("enemigos")
	
	var node_path_list = get_node("path").get_children()
	for node: Node2D in node_path_list:
		path_list.append(node.get_global_position())

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if current_position and get_global_position().x > path_list[current_position].x:
		velocity.x = -speed
	elif not current_position and get_global_position().x < path_list[current_position].x:
		velocity.x = speed
	else:
		current_position = !current_position
	
	sprite_inca.flip_h = current_position
	raycast_player.target_position.x = -player_distance if sprite_inca.flip_h else player_distance
	raycast_terrain.target_position.x = -terrain_distance if sprite_inca.flip_h else terrain_distance
		
	
	move_and_slide()
	
	if raycast_player.is_colliding():
		var raycast_collider = raycast_player.get_collider()
		if raycast_collider.is_in_group("Player"):
			target = raycast_collider
			new_target.emit(target)
			# Podria poner la funcion de atacar aqui
		raycast_terrain.force_raycast_update()
		if raycast_terrain.is_colliding():
			print(raycast_terrain.get_collider())
			current_position = !current_position
			
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("Player"):
			if collider.has_method("push"):
				collider.push(-get_slide_collision(i).get_normal())
				#receive_damage(5.0)
				break
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
