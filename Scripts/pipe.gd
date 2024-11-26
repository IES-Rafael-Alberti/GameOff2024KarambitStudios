extends TextureButton

var pipe_in: bool = false

enum PipeType {
	None,
	I,
	L,
	T
}

const ATLANTIS_PIPE_I = preload("res://Assets/Sprites/Puzzle3/atlantis_pipe_I.png")
const ATLANTIS_PIPE_L = preload("res://Assets/Sprites/Puzzle3/atlantis_pipe_L.png")
const ATLANTIS_PIPE_T = preload("res://Assets/Sprites/Puzzle3/atlantis_pipe_T.png")

@export var form_type = PipeType.None
@export var correct_rotation: float
@onready var pipe: TextureButton = $"."

func _ready():
	if form_type  == PipeType.I:
		pipe.texture_normal = ATLANTIS_PIPE_I
	elif form_type  == PipeType.L:
		pipe.texture_normal = ATLANTIS_PIPE_L
	elif form_type  == PipeType.T:
		pipe.texture_normal = ATLANTIS_PIPE_T
	pipe_in = rotation_degrees == correct_rotation
	pivot_offset = Vector2(16,16)
	

# Rota 90 grados a la izquierda
func rotate_left():
	rotation_degrees -= 90
	rotation_degrees = wrap_degrees(rotation_degrees)
	print(rotation_degrees," ", correct_rotation, " ", rotation_degrees == correct_rotation )
	check_correct_rotation()

# Rota 90 grados a la derecha
func rotate_right():
	rotation_degrees += 90
	rotation_degrees = wrap_degrees(rotation_degrees)
	print(rotation_degrees," ", correct_rotation, " ", rotation_degrees == correct_rotation )
	check_correct_rotation()

# Envuelve los grados al rango de 0 a 360
func wrap_degrees(value: float) -> float:
	while value < 0:
		value += 360
	while value >= 360:
		value -= 360
	return value

func check_correct_rotation():
	if form_type == PipeType.T or form_type == PipeType.L: 
		if rotation_degrees == correct_rotation:
			pipe_in = true
			print("Tuberia puesta!!")
		else:
			pipe_in = false
	elif form_type == PipeType.I:
		if rotation_degrees == correct_rotation or rotation_degrees == correct_rotation + 180 :
			pipe_in = true
			print("Tuberia puesta!!")		
		else:
			pipe_in = false
	
	get_parent().check_victory()

# Detectar clic izquierdo y derecho
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			rotate_left()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			rotate_right()
