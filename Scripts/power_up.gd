extends Sprite2D


@onready var power_up: Sprite2D = $"."
@onready var area_power_up: Area2D = $AreaPowerUp

@export var type:PowerType

enum PowerType {
	None,
	Flashlight,
	Doublejump,
	Dash
}


func _ready() -> void:
	# Verificar si el power-up ya está recogido
	if (type == PowerType.Flashlight and GameManager.flashlight) or (type == PowerType.Doublejump and GameManager.double_jump) or (type == PowerType.Dash and GameManager.dash):
		queue_free()  # Eliminar el power-up si ya está activado

func _on_area_power_up_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		if type == PowerType.Flashlight:
			print("Linterna recogida")

			GameManager.flashlight = true
		elif type == PowerType.Doublejump:
			print("Doble salto recogido")
			GameManager.double_jump = true
			body.MAX_JUMPS += 1
		elif type == PowerType.Dash:
			print("Dash recogido")
			GameManager.dash = true
			body.can_dash = true
		 
		queue_free()
