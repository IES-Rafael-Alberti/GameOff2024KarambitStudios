extends Sprite2D
@onready var arrow_thrower: Node2D = $"."
@onready var cooldown: Timer = $Cooldown
@onready var life_arrow_timer: Timer = $LifeArrowTimer
@onready var shooting_point: Node2D = $ShootingPoint


@export var shooting_point_pos: Vector2
var can_shoot = true
const ARROW = preload("res://Scenes/arrow.tscn")


func _physics_process(delta: float) -> void:
	shooting()

func shooting():
	if can_shoot:
		print("Dispara")
		var arrow_temp = ARROW.instantiate()

		arrow_temp.position = shooting_point.position 

		var arrow_direction: Vector2
		if arrow_thrower.flip_h:
			print("Disparo a la izquierda")
			arrow_direction = Vector2(-1, 0)  # Disparar hacia la izquierda
			arrow_temp.get_child(0).flip_h = true
		else:
			print("Disparo a la derecha")
			arrow_direction = Vector2(1, 0)
		arrow_temp.set_direction(arrow_direction)
		get_parent().add_child(arrow_temp)
		life_arrow_timer.start()
		can_shoot = false
		cooldown.start()
	


func _on_cooldown_timeout() -> void:
	can_shoot = true


func _on_life_arrow_timer_timeout() -> void:
# Busca la flecha (esto depende de cómo esté instanciada, aquí asumo que es un hijo directo)
	var arrow = get_parent().get_child(get_parent().get_child_count() - 1)  # Esto busca la última flecha añadida
	if arrow.name == "Arrow":
		print("Hay flecha")
		arrow.queue_free()  # Elimina la flecha de la escena
	else:
		print("No hay flecha")
