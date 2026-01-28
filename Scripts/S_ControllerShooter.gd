class_name ControllerShooter extends CharacterBody2D

@export var bullet_prefab : PackedScene
@export var speed: float = 500.0
@export var reload_time := 1

var can_shoot := true

func _ready():
	pass

func _physics_process(delta):
	
	if Input.is_action_pressed("Action") and can_shoot: _shoot()
	
	# Movements
	var direction_y := 0.0
	var direction_x := 0.0
	
	if Input.is_action_pressed("Move_Up"): direction_y -= 1
	if Input.is_action_pressed("Move_Down"): direction_y += 1
	if Input.is_action_pressed("Move_Left"): direction_x -= 1
	if Input.is_action_pressed("Move_Left"): direction_x -= 1
	if Input.is_action_pressed("Move_Right"): direction_x += 1

	var direction = Vector2(direction_x, direction_y).normalized()
	velocity = direction * speed

	move_and_slide()

	# Clamp position to screen
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _shoot():
	can_shoot = false

	var bullet = bullet_prefab.instantiate()
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)

	await get_tree().create_timer(reload_time).timeout
	can_shoot = true
