extends Sprite2D

var ready_to_puzle = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Action") and ready_to_puzle:
		get_node("/root/Player").queue_free()
		GameManager.player_node = null
		get_tree().change_scene_to_file("res://Scenes/Levels/puzzle_el_dorado.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.visible_e_key = true
		ready_to_puzle = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.visible_e_key = false
		ready_to_puzle = false
