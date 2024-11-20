extends Area2D
@onready var life_timer: Timer = $LifeTimer

# Velocidad del proyectil
var speed = 300

var direction = Vector2(1, 0)

func _ready() -> void:
	life_timer.start()
	
func _process(delta: float) -> void:
	position += direction * speed * delta

# Función para inicializar la dirección del proyectil
func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()



func _on_life_timer_timeout() -> void:
	queue_free() # Replace with function body.
