extends RigidBody2D

@onready var stone_life: Timer = $StoneLife


func _ready() -> void:
	stone_life.start()
	add_to_group("proyectile")

func _on_stone_cooldown_timeout() -> void:
	queue_free()
