extends Sprite2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.teleport_activate = true
		
