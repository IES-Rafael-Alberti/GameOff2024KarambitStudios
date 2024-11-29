extends Sprite2D

var can_shoot = true
enum BulletType {ARROW, BALL,ARROWVFX , NONE}
enum SceneType {DORADO,DUAT,ATLANTIS}

@onready var cooldown: Timer = $Cooldown
@onready var shooting_point: Node2D = $ShootingPoint
@onready var thrower: Sprite2D = $"."


@export var type: BulletType = BulletType.NONE
@export var bullet_speed: float
@export var life_time: float
@export var cooldown_time: float
@export var scene_type: SceneType



const BULLET = preload("res://Scenes/Proyectiles/bullet.tscn")
const ARROW_V_2 = preload("res://Assets/Sprites/Proyectiles/arrow_v2.png")
const ENERGY_BALL = preload("res://Assets/Sprites/Proyectiles/Energy Ball.png")
const SPRITE_BOLA_DE_AGUA_ATLANTIDA = preload("res://Assets/Sprites/Proyectiles/sprite_bola_de_agua_atlantida.png")
const SPRITE_LANZADOR_DE_PROYECTILES_VERSION_ATLANTIDA = preload("res://Assets/Sprites/Traps/sprite_lanzador_de_proyectiles_version_atlantida.png")
const SPRITE_LANZADOR_DE_PROYECTILES_VERSION_DORADO = preload("res://Assets/Sprites/Traps/sprite_lanzador_de_proyectiles_version_dorado.png")
const SPRITE_LANZADOR_DE_PROYECTILES_VERSION_DUAT = preload("res://Assets/Sprites/Traps/sprite_lanzador_de_proyectiles_version_duat.png")
func _ready() -> void:
	if scene_type == SceneType.DORADO:
		texture = SPRITE_LANZADOR_DE_PROYECTILES_VERSION_DORADO
	elif scene_type == SceneType.ATLANTIS:
		texture = SPRITE_LANZADOR_DE_PROYECTILES_VERSION_ATLANTIDA
	if scene_type == SceneType.DUAT:
		texture = SPRITE_LANZADOR_DE_PROYECTILES_VERSION_DUAT

func _physics_process(delta: float) -> void:
	shooting()

func shooting():
	if can_shoot and type != BulletType.NONE:
		#print("Dispara")
		var bullet_temp = BULLET.instantiate()
		var bullet_sprite = bullet_temp.get_node_or_null("BulletSprite")
		if bullet_sprite:
			if type == BulletType.ARROW:
				bullet_sprite.play("Arrow")  # Cambia la textura del sprite
			elif type == BulletType.BALL:
				bullet_sprite.play("AquaBall")
				bullet_temp.scale = Vector2(0.6,0.6)
			elif type == BulletType.ARROWVFX:
				bullet_sprite.play("ArrowWithParticles")
		var bullet_direction: Vector2
		if thrower.flip_h:
			bullet_direction = Vector2(-1, 0)  # Disparar hacia la izquierda
			bullet_temp.get_node("BulletSprite").flip_h = true
		else:
			bullet_direction = Vector2(1, 0)
		bullet_temp.set_direction(bullet_direction)
		bullet_temp.position = shooting_point.position 
		bullet_temp.speed = bullet_speed
		
		cooldown.wait_time = cooldown_time
		thrower.add_child(bullet_temp)
		bullet_temp.life_timer.wait_time = life_time
		bullet_temp.life_timer.start()
		can_shoot = false
		cooldown.start()
	


func _on_cooldown_timeout() -> void:
	can_shoot = true


func _on_life_timer_timeout() -> void:
	
# Busca la flecha (esto depende de cómo esté instanciada, aquí asumo que es un hijo directo)
	var bullet = get_node("Bullet")
	print(bullet.name)
	if bullet.type != BulletType.BALL:
		bullet.queue_free()
		print("Borrar bala")
	else:
		bullet.play("AquaBallBreak")
		
