extends Area2D


func _on_body_entered(body: Node2D) -> void:
	get_node("/root/Player").queue_free()
	# Opcional: Si necesitas reiniciar alguna otra variable o estado del jugador, lo haces aquí.
	# Aquí restablecemos la vida del jugador a MAX_HEALTH.
	GameManager.player_health = GameManager.MAX_HEALTH  # O también puedes hacerlo directamente en el jugador
	# Recargar la escena
	get_tree().reload_current_scene()
