extends Control

# Referencia a los iconos de corazón
@onready var heart_icons = $HeartsContainer.get_children()  # Todos los corazones como una lista

# Función para actualizar la vida mostrada en el HUD
func update_health(current_health: int):
	# Activa o desactiva los corazones según la vida actual
	for i in range(heart_icons.size()):
		heart_icons[i].visible = i < current_health  # Muestra los corazones según la vida actual
