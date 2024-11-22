extends Control

# Texturas para corazones
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D


@onready var empty_heart: Sprite2D = $HeartBar/EmptyHeart
@onready var full_heart: Sprite2D = $HeartBar/FullHeart
@onready var score_label: Label = $ScoreLabel
@onready var charges: Sprite2D = $Battery/Charges

func _process(delta: float) -> void:
	empty_heart.region_rect.size.x = empty_heart.texture.get_size().x * GameManager.MAX_HEALTH
	full_heart.region_rect.size.x = full_heart.texture.get_size().x * GameManager.player_health
	score_label.text = str(GameManager.score)
	charges.region_rect.size.x = charges.texture.get_size().x * GameManager.flash_count
