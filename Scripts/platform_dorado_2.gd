extends AnimatableBody2D

@export var flip_h: bool = false
@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.flip_h = flip_h
