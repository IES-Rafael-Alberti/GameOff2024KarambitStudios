extends Node2D
@onready var spawn_point: Node2D = $SpawnPoint

const PLAYER = preload("res://Scenes/player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1.0

	var player_node = PLAYER.instantiate()
	player_node.set_global_position(spawn_point.get_global_position())
	get_tree().root.add_child(player_node)
