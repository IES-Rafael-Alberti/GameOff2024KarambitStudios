extends VBoxContainer

@onready var master_volume_slider: HSlider = $MasterVolumeSlider
@onready var music_volume_slider: HSlider = $MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $SFXVolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
