extends TextureButton

@onready var pieces: Node2D = $".."

var initial_position: Vector2
var is_dragging: bool = false
var offset: Vector2 = Vector2.ZERO

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
	# Inicializamos la lista de piezas correctas en 'false'
	

# Detecta el clic para iniciar el arrastre
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not colocada:
		if event.pressed:
			is_dragging = true
			offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false
			if global_position.distance_to(correct_positions[piece_index]) < threshold:
				global_position = correct_positions[piece_index]  # Coloca la pieza en la posición correcta
				print(global_position)
				correct_pieces.append(true)  # Marca esta pieza como colocada correctamente
				colocada = true
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
	GameManager.puzzle_1_complete = true
	get_tree().change_scene_to_file("res://Scenes/Levels/museum_scene.tscn")
	
