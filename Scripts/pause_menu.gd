extends Control

signal resume_requested  # Señal para reanudar el juego


func _on_return_to_menu_pressed() -> void:
	get_node("/root/Player").queue_free()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
