extends RigidBody2D

@onready var stone_life: Timer = $StoneLife


func _ready() -> void:
	stone_life.start()






func _on_stone_cooldown_timeout() -> void:
	queue_free()





func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
