extends Sprite2D

var points:int


@onready var collectable: Sprite2D = $"."

@export var coin_points: int = 10
@export var gem_points: int = 100
@export var type:CollectableType

const COIN = preload("res://Assets/Sprites/Collectable/Coin.png")
const GEM_V_1 = preload("res://Assets/Sprites/Collectable/Gem_v1.png")

enum CollectableType {
	None,
	Coin,
	Gem
}
func _ready() -> void:
	if type == CollectableType.Coin:
		collectable.texture == COIN
		points = coin_points
	elif type == CollectableType.Gem:
		collectable.texture == GEM_V_1
		points = gem_points
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.score += points
		queue_free()
