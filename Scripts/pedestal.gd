extends Sprite2D

@export var scene_name: String


func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.teleport_activate = true
		GameManager.teleport_destination = scene_name
		



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.teleport_activate = false
		GameManager.teleport_destination = ""


	
