extends Sprite2D

@onready var cooldown: Timer = $Cooldown


@export var damage: float = 1.0


func _on_damage_area_body_entered(body: Node2D) -> void:
	GameManager.take_damage(damage)
