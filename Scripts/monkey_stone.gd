extends RigidBody2D

func _ready() -> void:
	# Espera 3 segundos y luego elimina la piedra
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func _process(delta: float) -> void:
	if (player.global_position - global_position).length() < 200:  # Ajusta el rango
		throw_stone()


func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		queue_free()  # Elimina la piedra al chocar con el jugador
