extends Sprite2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if GameManager.player_health < GameManager.MAX_HEALTH:
			GameManager.player_health += 1
			queue_free()
		
