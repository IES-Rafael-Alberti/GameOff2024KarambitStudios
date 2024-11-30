extends Control
# SONIDO
@onready var rain_sound: AudioStreamPlayer = $Rain/RainSound
@onready var music_player: AudioStreamPlayer = $Rain/MusicPlayer
#MENUS

@onready var first_menu: VBoxContainer = $Panel/BackGroundButton/FirstMenu
@onready var options_menu: VBoxContainer = $Panel/BackGroundButton/OptionsMenu

func _ready() -> void:
	Engine.time_scale = 1.0
	rain_sound.play()
	music_player.play()
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/museum_scene.tscn")

func _on_options_pressed() -> void:
	first_menu.visible = false
	options_menu.visible = true


func _on_back_pressed() -> void:
	first_menu.visible = true
	options_menu.visible = false
