extends Area2D

# Indica si esta celda está ocupada
var is_occupied: bool = false

# Marca la celda como ocupada o libre
func set_occupied(state: bool) -> void:
	is_occupied = state
