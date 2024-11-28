extends AnimatedSprite2D

@onready var cooldown: Timer = $Cooldown
@onready var spikes: AnimatedSprite2D = $"."


@export var damage: float = 1.0
@export var scene_type: SceneType = SceneType.DORADO

const SPRITE_PINCHOS_ATLANTIDA = preload("res://Assets/Sprites/Traps/sprite_pinchos_atlantida.png")
const SPRITE_PINCHOS_DUAT = preload("res://Assets/Sprites/Traps/sprite_pinchos_duat.png")
enum SceneType {
	DORADO,
	DUAT,
	ATLANTIS
}

func _ready() -> void:
	if scene_type == SceneType.DORADO:
		spikes.play("Dorado")
	elif scene_type == SceneType.DUAT:
		spikes.play("Duat")
	elif scene_type == SceneType.DUAT:
		spikes.play("Atlantis")
func _on_damage_area_body_entered(body: Node2D) -> void:
	GameManager.take_player_damage(body)
