extends GridContainer
@onready var pipe_board: GridContainer = $"."

@onready var pipe: TextureButton = $Pipe
@onready var pipe_2: TextureButton = $Pipe2
@onready var pipe_3: TextureButton = $Pipe3
@onready var pipe_4: TextureButton = $Pipe4
@onready var pipe_5: TextureButton = $Pipe5
@onready var pipe_6: TextureButton = $Pipe6
@onready var pipe_7: TextureButton = $Pipe7
@onready var pipe_8: TextureButton = $Pipe8
@onready var pipe_9: TextureButton = $Pipe9
@onready var pipe_10: TextureButton = $Pipe10
@onready var pipe_11: TextureButton = $Pipe11
@onready var pipe_12: TextureButton = $Pipe12
@onready var pipe_13: TextureButton = $Pipe13
@onready var pipe_14: TextureButton = $Pipe14
@onready var pipe_15: TextureButton = $Pipe15
@onready var pipe_16: TextureButton = $Pipe16

@onready var pause_menu: Control = $"../../../UI/PauseMenu"
@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"

var victory: bool = false
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause_menu.visible = not pause_menu.visible
func check_victory():
	for pipe in get_children():
		if pipe.name != "Pipe2" and pipe is TextureButton:  # Ignora la pieza "Pipe2"
			if not pipe.pipe_in:  # Si alguna pieza no está correctamente colocada
				print("Aún no está resuelto.")
				return  # Sale de la función porque el rompecabezas no está resuelto
	print("¡Victoria!")  # Si todas las piezas están bien, imprime victoria
	GameManager.puzzle_3_complete = true
	GameManager.score += 1000
	GameManager.save_score = GameManager.score
	GameManager.save_kill = GameManager.kill_count
	GameManager.save_coin = GameManager.coin_count
	GameManager.save_gem = GameManager.gem_count
	victory = true
	animation_player.play("artifact_collected")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "artifact_collected":
		get_tree().change_scene_to_file("res://Scenes/Collectables/victory_screen.tscn")
