extends Control

@onready var options_menu: VBoxContainer = $Background/OptionsMenu

func _on_return_to_menu_pressed() -> void:
	if get_node("/root/Player"):
		get_node("/root/Player").queue_free()
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")


func _on_options_pressed() -> void:
	options_menu.visible = not options_menu.visible
