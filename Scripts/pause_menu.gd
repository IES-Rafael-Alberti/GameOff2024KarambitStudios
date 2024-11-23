extends Control


func _on_return_to_menu_pressed() -> void:
	get_node("/root/Player").queue_free()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")



func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	get_tree().paused = false
