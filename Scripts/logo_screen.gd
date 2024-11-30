extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var karambit_studios_logo_contorno_blanco_: TextureRect = $"KarambitStudiosLogo(contornoBlanco)"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "logo_animation":
		get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
