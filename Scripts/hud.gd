extends Control


# Texturas para corazones
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

@onready var heart_icons = $HealthContainer  # Contenedor de corazones

func _ready() -> void:
	heart_establish()

func heart_establish():
	# Añade 3 corazones con la textura llena
	for i in range(3):
		var heart = TextureRect.new()
		heart.texture = full_heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Asegura que la textura se vea correctamente
		heart_icons.add_child(heart)
