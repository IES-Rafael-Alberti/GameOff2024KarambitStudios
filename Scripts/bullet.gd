extends Area2D



var direction = Vector2(1, 0)

# Velocidad del proyectil
@export var speed = 300
@export var damage: float = 1.0
@export var image: Texture2D



@onready var bullet_sprite: Sprite2D = $BulletSprite
@onready var arrow_collider: CollisionShape2D = $ArrowCollider
@onready var ball_collider: CollisionShape2D = $BallCollider



func _process(delta: float) -> void:
	position += direction * speed * delta

# Función para inicializar la dirección del proyectil
func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()


func _on_body_entered(body: Node2D) -> void:
	GameManager.take_damage(damage)
