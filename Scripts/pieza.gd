extends TextureButton

@onready var pieces: Node2D = $".."
const SHINE_PIECE = preload("res://Shaders/ShinePiece.gdshader")
var initial_position: Vector2
var is_dragging: bool = false
var offset: Vector2 = Vector2.ZERO
@onready var rock_pop_sound: AudioStreamPlayer = $RockPopSound
@onready var pause_menu: Control = $"../../UI/PauseMenu"
@onready var artifact: Sprite2D = $"../../Artifact"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var reset_button: TextureButton = $"../../ResetButton"
@onready var level_complete: AudioStreamPlayer2D = $"../../LevelComplete"

# Array con las posiciones correctas de las piezas
var correct_positions = [
	Vector2(-1, 12),  # Posición correcta para la pieza 1
	Vector2(27, -5),  # Posición correcta para la pieza 2
	Vector2(27, 28),  # Posición correcta para la pieza 3
	Vector2(-1, 32),  # Posición correcta para la pieza 4
	Vector2(5, -1),   # Posición correcta para la pieza 5
	Vector2(21, 16),  # Posición correcta para la pieza 6
	Vector2(38, 10),  # Posición correcta para la pieza 7
	Vector2(27, 39)   # Posición correcta para la pieza 8
]

var threshold: float = 3.0  # Umbral de distancia para considerarlo "cerca"
@export var piece_index: int  # Índice de la pieza actual (puede configurarse en el editor o calcularse)

# Lista para comprobar si las piezas están colocadas correctamente
var correct_pieces: Array[bool] = []  # Guardamos un estado de las piezas correctas

var colocada = false

func _ready():
	initial_position = global_position
	material.shader = null
	artifact.visible = false
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		print("Pause")
		pause_menu.visible = not pause_menu.visible
		
# Detecta el clic para iniciar el arrastre
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not colocada:
		if event.pressed:
			is_dragging = true
			offset = get_global_mouse_position() - global_position
			z_index +=1
			rock_pop_sound.play()
		else:
			is_dragging = false
			if global_position.distance_to(correct_positions[piece_index]) < threshold:
				global_position = correct_positions[piece_index]  # Coloca la pieza en la posición correcta
				print(global_position)
				correct_pieces.append(true)  # Marca esta pieza como colocada correctamente
				colocada = true
				material.shader = SHINE_PIECE
				z_index -= 1
				check_victory()
			else:
				colocada = false
	elif event is InputEventMouseMotion and is_dragging:
		# Mueve la pieza mientras arrastras
		global_position = get_global_mouse_position() - offset
func check_victory():
	for piece in pieces.get_children():
		if piece.colocada == false:
			return
	print("Victoria")
	animation_player.play("artifact_collected")
	level_complete.play()
	GameManager.puzzle_1_complete = true
	GameManager.score += 1000
	GameManager.save_score = GameManager.score
	GameManager.save_kill = GameManager.kill_count
	GameManager.save_coin = GameManager.coin_count
	GameManager.save_gem = GameManager.gem_count
	reset_button.visible = false
	


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "artifact_collected":
		get_tree().change_scene_to_file("res://Scenes/Collectables/victory_screen.tscn")
	
