extends Control

@onready var rain_sound: AudioStreamPlayer2D = $Panel/BackGround/RainSound

func _ready() -> void:
	rain_sound.play()
	
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/museum_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
