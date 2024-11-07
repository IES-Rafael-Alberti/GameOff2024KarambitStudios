extends CharacterBody2D

@onready var pause_menu: Control = $UI/PauseMenu
@onready var e_key: Sprite2D = $EKey

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	pause_menu.visible = false
	
func _physics_process(delta: float) -> void:
	if GameManager.teleport_activate == true:
		e_key.visible = true
	else:
		e_key.visible = false 
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

	if GameManager.teleport_activate == true and Input.is_action_just_pressed("Action"):
		#print(scene_name)
		teleport_to_scene(GameManager.teleport_destination)

	# Handle jump.
	if Input.is_action_just_pressed("Jump"	) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	move_and_slide()
	
func toggle_pause():
	if $UI/PauseMenu.visible:
		# Si el menú está visible, reanuda el juego y oculta el menú
		$UI/PauseMenu.visible = false
		Engine.time_scale = 1.0
	else:
		# Si el menú no está visible, pausa el juego y muestra el menú
		$UI/PauseMenu.visible = true
		Engine.time_scale = 0.0

func teleport_to_scene(scene:String):
	if GameManager.teleport_activate:
		get_node("/root/Player").queue_free()
		get_tree().change_scene_to_file("res://Scenes/"+scene+".tscn")
