extends Area2D


# Velocidad del proyectil
@export var speed = 300

var direction = Vector2(1, 0)


func _process(delta: float) -> void:
	position += direction * speed * delta

# Función para inicializar la dirección del proyectil
func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()
