extends Node2D
@onready var spawn_point: Node2D = $SpawnPoint
@onready var pedestal_el_dorado: Sprite2D = $Pedestals/PedestalElDorado
@onready var pedestal_atlantis: Sprite2D = $Pedestals/PedestalAtlantis
@onready var pedestal_duat: Sprite2D = $Pedestals/PedestalDuat
@onready var dorado_music_player: AudioStreamPlayer = $DoradoMusicPlayer

const PLAYER = preload("res://Scenes/Characters/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1.0
	if scene_file_path.contains("museum_scene"):
		
		pedestal_atlantis.visible = false
		pedestal_atlantis.get_child(0).get_child(0).disabled = true
		if GameManager.puzzle_1_complete:
			if pedestal_el_dorado:
				pedestal_el_dorado.get_child(0).get_child(0).disabled = true
		
		if GameManager.puzzle_2_complete:
			if pedestal_duat:
				pedestal_duat.get_child(0).get_child(0).disabled = true
		
		if GameManager.puzzle_1_complete and GameManager.puzzle_2_complete:
			pedestal_atlantis.visible = true
			pedestal_atlantis.get_child(0).get_child(0).disabled = false

		if GameManager.puzzle_3_complete:
			pedestal_atlantis.get_child(0).get_child(0).disabled = true
	elif scene_file_path.contains("dorado_scene"):
		if  dorado_music_player:
			dorado_music_player.play()
		
	if scene_file_path.contains("duat_scene") and GameManager.return_point and GameManager.returning_puzzle_2:
		spawn_point.position = GameManager.return_point
		GameManager.returning_puzzle_2 = false
	var player_node = PLAYER.instantiate()
	player_node.set_global_position(spawn_point.get_global_position())
	GameManager.player_health = GameManager.MAX_HEALTH
	GameManager.flash_count = 5
	get_tree().root.add_child(player_node)
	GameManager.player_node = player_node
	GameManager.score = GameManager.save_score
	GameManager.kill_count = GameManager.save_kill
	GameManager.coin_count = GameManager.save_coin
	GameManager.gem_count = GameManager.save_gem

	
	
