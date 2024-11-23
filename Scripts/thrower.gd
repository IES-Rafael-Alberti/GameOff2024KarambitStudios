extends Sprite2D

var can_shoot = true
enum BulletType {ARROW, BALL, NONE}


@onready var cooldown: Timer = $Cooldown
@onready var life_timer: Timer = $LifeTimer
@onready var shooting_point: Node2D = $ShootingPoint
@onready var thrower: Sprite2D = $"."



@export var type: BulletType = BulletType.NONE
@export var bullet_speed: float
@export var life_time: float
@export var cooldown_time: float

const BULLET = preload("res://Scenes/Proyectiles/bullet.tscn")
const ARROW_V_2 = preload("res://Assets/Sprites/Proyectiles/arrow_v2.png")
const ENERGY_BALL = preload("res://Assets/Sprites/Proyectiles/Energy Ball.png")


func _physics_process(delta: float) -> void:
	shooting()

func shooting():
	if can_shoot and type != BulletType.NONE:
		#print("Dispara")
		var bullet_temp = BULLET.instantiate()
		var bullet_sprite = bullet_temp.get_node_or_null("BulletSprite")
		if bullet_sprite:
			if type == BulletType.ARROW:
				bullet_sprite.texture = ARROW_V_2  # Cambia la textura del sprite
			elif type == BulletType.BALL:
				bullet_sprite.texture = ENERGY_BALL
		
		var bullet_direction: Vector2
		if thrower.flip_h:
			bullet_direction = Vector2(-1, 0)  # Disparar hacia la izquierda
			bullet_temp.get_node("BulletSprite").flip_h = true
		else:
			bullet_direction = Vector2(1, 0)
		bullet_temp.set_direction(bullet_direction)
		bullet_temp.position = thrower.position + shooting_point.position 
		bullet_temp.speed = bullet_speed
		life_timer.wait_time = life_time
		cooldown.wait_time = cooldown_time
		get_parent().add_child(bullet_temp)
		bullet_temp.name = "Bullet"
		life_timer.start()
		can_shoot = false
		cooldown.start()
	


func _on_cooldown_timeout() -> void:
	can_shoot = true


func _on_life_timer_timeout() -> void:
	
# Busca la flecha (esto depende de cómo esté instanciada, aquí asumo que es un hijo directo)
	var bullet = get_parent().get_child(get_parent().get_child_count() - 1)  # Esto busca la última flecha añadida
	print(bullet.name)
	if bullet.name.contains("Bullet"):
		print("Borrar bala")
		bullet.queue_free()  # Elimina la flecha de la escena
	
