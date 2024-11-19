extends Sprite2D

# Referencia a todas las celdas (se asignan manualmente en el editor)
@export var cells: Array[Area2D] = []

func _ready() -> void:
	# Si no asignas las celdas manualmente en el editor, puedes buscarlas automáticamente:
	if cells.is_empty():
		var cells_node = $Cells  # Nodo que contiene todas las celdas
		for child in cells_node.get_children():
			if child is Area2D:
				cells.append(child)

# Encuentra la celda más cercana a una posición
func get_nearest_cell(position: Vector2) -> Area2D:
	var nearest_cell: Area2D = null
	var shortest_distance: float = INF  # Valor infinito

	for cell in cells:
		var distance = position.distance_to(cell.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_cell = cell

	return nearest_cell

# Verifica si las celdas de la pieza pueden colocarse en el tablero
func can_place_piece(piece_cells: Array[Vector2]) -> bool:
	for piece_cell in piece_cells:
		var nearest_cell = get_nearest_cell(piece_cell)
		if not nearest_cell or nearest_cell.is_occupied:
			return false
	return true


# Marca todas las celdas cercanas como ocupadas o libres
func place_piece(piece_cells: Array[Vector2], state: bool) -> void:
	for piece_cell in piece_cells:
		var nearest_cell = get_nearest_cell(piece_cell)
		if nearest_cell:
			nearest_cell.set_occupied(state)
