extends Area2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sinking_time: Timer = $SinkingTime

var player: CharacterBody2D

func _on_body_entered(body: Node):
	if body.name == "Player":
		print("Ha entrao el jugador") 
		player = body
		body.is_sinking = true
		sinking_time.start()
	

func _on_sinking_time_timeout() -> void:
	player.queue_free()
	get_tree().reload_current_scene()
