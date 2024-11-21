extends Sprite2D
@onready var arrow_thrower: Node2D = $"."
@onready var cooldown: Timer = $Cooldown

@export var shooting_point_pos: Vector2
var can_shoot = true
const ARROW = preload("res://Scenes/arrow.tscn")

func _physics_process(delta: float) -> void:
	shooting()

func shooting():
	if can_shoot:
		print("Dispara")
		var arrow_temp = ARROW.instantiate()

		arrow_temp.position = shooting_point_pos

		var arrow_direction: Vector2
		if arrow_thrower.flip_h:
			arrow_direction = Vector2(-1, 0)  # Disparar hacia la izquierda
		else:
			arrow_direction = Vector2(1, 0)
		arrow_temp.set_direction(arrow_direction)
		get_parent().add_child(arrow_temp)
		can_shoot = false
		cooldown.start()
	


func _on_cooldown_timeout() -> void:
	can_shoot = true
