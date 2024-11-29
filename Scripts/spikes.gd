extends AnimatedSprite2D

@onready var cooldown: Timer = $Cooldown
@onready var spikes: AnimatedSprite2D = $"."


@export var damage: float = 1.0
@export var scene_type: SceneType = SceneType.DORADO


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
	elif scene_type == SceneType.ATLANTIS:
		spikes.play("Atlantis")
func _on_damage_area_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		GameManager.take_player_damage(body)
