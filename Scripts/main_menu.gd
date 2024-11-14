extends Control
# SONIDO
@onready var rain_sound: AudioStreamPlayer2D = $Rain/RainSound
#MENUS

@onready var first_menu: VBoxContainer = $Panel/BackGroundButton/FirstMenu
@onready var options_menu: VBoxContainer = $Panel/BackGroundButton/OptionsMenu

# OPCIONES DE VENTANA
@onready var screen_options: OptionButton = $Panel/BackGroundButton/OptionsMenu/SreenMode/ScreenOptions

# BARRAS DE VOLUMEN
@onready var master_volume_bar: HScrollBar = $Panel/BackGroundButton/OptionsMenu/Volume/HBoxContainer/MasterVolumeColum/MasterVolumeBar
@onready var effects_volume_bar: HScrollBar = $Panel/BackGroundButton/OptionsMenu/Volume/HBoxContainer/MasterVolumeColum2/EffectsVolumeBar

func _ready() -> void:
	Engine.time_scale = 1.0

	rain_sound.play()
	
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/museum_scene.tscn")

func _on_options_pressed() -> void:
	first_menu.visible = false
	options_menu.visible = true


func _on_back_pressed() -> void:
	first_menu.visible = true
	options_menu.visible = false


func _on_master_volume_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)  # Ajusta el volumen en el bus principal


func _on_effects_volume_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)  # Ajusta el volumen en el bus de efectos


func _on_screen_options_item_selected(index: int) -> void:
	if index == 0:  # Modo Ventana
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:  # Pantalla Completa
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
