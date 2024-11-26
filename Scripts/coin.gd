extends Sprite2D


@export var points:int = 10



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.score += points
		queue_free()
