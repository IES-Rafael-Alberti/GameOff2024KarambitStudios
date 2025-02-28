extends Sprite2D

@onready var button_left_top: TextureButton = $ButtonLeftTop
@onready var button_right_top: TextureButton = $ButtonRightTop
@onready var button_left_mid: TextureButton = $ButtonLeftMid
@onready var button_right_mid: TextureButton = $ButtonRightMid
@onready var button_left_bottom: TextureButton = $ButtonLeftBottom
@onready var button_right_bottom: TextureButton = $ButtonRightBottom

@onready var level_complete: AudioStreamPlayer2D = $"../LevelComplete"

@onready var top_piece: Sprite2D = $"../TopPiece"
@onready var mid_piece: Sprite2D = $"../MidPiece"
@onready var bottom_piece: Sprite2D = $"../BottomPiece"
const PLAYER = preload("res://Scenes/Characters/player.tscn")
# Texturas de las piezas
var top_textures = [
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_top_1.png"),
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_top_2.png"),
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_top_3.png")
]

var mid_textures = [
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_mid_1.png"),
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_mid_2.png"),
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_mid_3.png")
]

var bottom_textures = [
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_bottom_1.png"),
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_bottom_2.png"),
	preload("res://Assets/Sprites/Puzzle2/duat_pieza_bottom_3.png")
]

var victory = false

# Índices actuales
var index_top: int = 0
var index_mid: int = 0
var index_bottom: int = 0

# Índices objetivos para ganar
const TARGET_TOP_INDEX = 2
const TARGET_MID_INDEX = 1
const TARGET_BOTTOM_INDEX = 1

@onready var artifact: Sprite2D = $"../Artifact"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

@onready var pause_menu: Control = $"../UI/PauseMenu"
@onready var return_button_duat: TextureButton = $"../ReturnButtonDuat"

func _ready() -> void:
	update_pieces()
	artifact.visible = false
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause_menu.visible = not pause_menu.visible
# Actualiza las piezas según sus índices
func update_pieces():
	top_piece.texture = top_textures[index_top]
	mid_piece.texture = mid_textures[index_mid]
	bottom_piece.texture = bottom_textures[index_bottom]
	check_victory()

# Verifica si todos los índices están en el estado objetivo
func check_victory():
	if index_top == TARGET_TOP_INDEX and index_mid == TARGET_MID_INDEX and index_bottom == TARGET_BOTTOM_INDEX:
		GameManager.puzzle_2_complete = true
		GameManager.score += 1000
		GameManager.save_score = GameManager.score
		GameManager.save_kill = GameManager.kill_count
		GameManager.save_coin = GameManager.coin_count
		GameManager.save_gem = GameManager.gem_count
		print("victoria")
		victory = true
		return_button_duat.visible = false
		animation_player.play("artifact_collected")
		level_complete.play()
# Mueve el índice de la pieza superior a la derecha
func _on_button_left_top_pressed() -> void:
	if not victory:
		index_top = (index_top - 1 + top_textures.size()) % top_textures.size()  # Retrocede (circular)
		print(index_top)
		update_pieces()

# Mueve el índice de la pieza superior a la izquierda
func _on_button_right_top_pressed() -> void:
	if not victory:
		index_top = (index_top + 1) % top_textures.size()  # Avanza al siguiente símbolo (circular)
		print(index_top)
		update_pieces()

# Implementa las funciones de los otros botones de la misma manera
func _on_button_left_mid_pressed() -> void:
	if not victory:
		index_mid = (index_mid - 1 + mid_textures.size()) % mid_textures.size()
		print(index_mid)
		update_pieces()

func _on_button_right_mid_pressed() -> void:
	if not victory:
		index_mid = (index_mid + 1) % mid_textures.size()
		print(index_mid)
		update_pieces()

func _on_button_left_bottom_pressed() -> void:
	if not victory:
		index_bottom = (index_bottom - 1 + bottom_textures.size()) % bottom_textures.size()
		print(index_bottom)
		update_pieces()

func _on_button_right_bottom_pressed() -> void:
	if not victory:
		index_bottom = (index_bottom + 1) % bottom_textures.size()
		print(index_bottom)
		update_pieces()
		

func _on_return_button_duat_pressed() -> void:
	GameManager.returning_puzzle_2 = true
	get_tree().change_scene_to_file("res://Scenes/Levels/duat_scene.tscn")
	
	
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "artifact_collected":
		victory = false
		get_tree().change_scene_to_file("res://Scenes/Collectables/victory_screen.tscn")
		
