extends RigidBody2D

@onready var stone_life: Timer = $StoneLife
@onready var sprite_list : Array[Texture2D] = [
	preload("res://Assets/Sprites/monkey_banana.png"),
	preload("res://Assets/Sprites/monkey_poop.png"),
	preload("res://Assets/Sprites/monkey_stone.png")
]
@onready var sprite_stone = $SpriteStone

func _ready() -> void:
	asign_sprite()
	stone_life.start()
	add_to_group("proyectile")

func _on_stone_cooldown_timeout() -> void:
	queue_free()

func asign_sprite() -> void:
	if sprite_list.size() > 0:  # Asegúrate de que el array no esté vacío
		var random_index = randi() % sprite_list.size()
		sprite_stone.texture = sprite_list[random_index]  # Asigna la textura
