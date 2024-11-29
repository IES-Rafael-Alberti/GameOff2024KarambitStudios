extends Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("logo_move")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "logo_move":
		get_tree().change_scene_to_file("res://Scenes/Levels/museum_scene.tscn")
