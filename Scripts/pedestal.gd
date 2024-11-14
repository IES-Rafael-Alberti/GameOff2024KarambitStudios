extends Sprite2D

@export var scene_name: String


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.teleport_activate = true
		GameManager.teleport_destination = scene_name  # Asigna el nombre de la escena

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.teleport_activate = false
		GameManager.teleport_destination = ""  # Borra el destino del teletransporte cuando el jugador sale
