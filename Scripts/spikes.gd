extends Sprite2D

#@onready var cooldown: Timer = $Cooldown

func _on_damage_area_body_entered(body: Node2D) -> void:
	GameManager.muerte()
