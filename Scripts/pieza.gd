extends TextureButton

# Variables para la posición inicial y seguimiento del tablero
var initial_position: Vector2
var is_dragging: bool = false
@onready var tablero_dorado: Sprite2D = $"../TableroDorado"
var offset :Vector2 = Vector2.ZERO


@export var piece_cells: Array[Area2D] = []  # Celdas asociadas a la pieza

func _ready() -> void:
	initial_position = global_position
	# Asegúrate de que las celdas de la pieza estén dentro del arreglo
	piece_cells = get_piece_cells()

## Detecta el clic para iniciar el arrastre
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			is_dragging = true
			offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false
			place_piece()
	elif event is InputEventMouseMotion and is_dragging:
		# Mueve la pieza y sus celdas
		global_position = get_global_mouse_position() - offset

## Obtén las celdas de la pieza
func get_piece_cells() -> Array[Area2D]:
	var cells: Array[Area2D] = []
	for child in get_children():
		if child is Area2D:
			cells.append(child)
	return cells
#
## Mueve las celdas de la pieza junto con la pieza
#func move_piece_cells() -> void:
	#for cell in piece_cells:
		## Mueve las celdas al mismo tiempo que la pieza
		#cell.global_position = global_position + (cell.position - piece_cells[0].position)
#
## Coloca la pieza en el tablero o la resetea si no está correctamente posicionada
func place_piece():
	# Obtén las posiciones globales de las celdas de la pieza
	var piece_cells_positions = get_piece_cells_positions(tablero_dorado.cells)
	print(piece_cells_positions.size())
	# Verifica si las posiciones no están vacías
	if piece_cells_positions.size() > 0:
		if tablero_dorado.can_place_piece(piece_cells_positions):
			# Coloca la pieza en las celdas del tablero
			tablero_dorado.place_piece(piece_cells_positions, true)
			
			# Alinea las celdas de la pieza con el tablero
			# La primera celda de la pieza debe alinearse con la celda más cercana del tablero
			var first_cell = tablero_dorado.get_nearest_cell(piece_cells_positions[0])

			if first_cell:
				# Establece la posición global de la pieza en la posición de la primera celda del tablero
				global_position = first_cell.global_position
				
				# Ahora ajustamos las posiciones de las celdas de la pieza
		else:
			# Si no se puede colocar, resetea la pieza a su posición inicial
			global_position = initial_position
	else:
		global_position = initial_position

		print("Error: Las posiciones de las celdas de la pieza están vacías.")
		
func get_table_cell_positions():
	pass
func get_piece_cells_positions(piece_cells: Array) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for cell in piece_cells:
		# Añadimos la posición global de cada celda
		positions.append(cell.global_position)
		
	return positions
	
#func align_piece_cells_on_board(first_cell: Area2D) -> void:
	## Calculamos el desplazamiento relativo entre la primera celda de la pieza y el tablero
	#var offset = first_cell.global_position - piece_cells[0].global_position
	#
	## Mover todas las celdas de la pieza de acuerdo con el offset calculado
	#for cell in piece_cells:
		#cell.global_position += offset
