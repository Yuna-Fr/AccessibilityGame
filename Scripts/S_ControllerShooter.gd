class_name ControllerShooter extends CharacterBody2D

@export var speed: float = 500.0

func _ready():
	pass

func _physics_process(delta):
	var direction := 0.0
	
	if Input.is_action_pressed("Action"): _shoot()
	if Input.is_action_pressed("Move_Up"): direction -= 1
	if Input.is_action_pressed("Move_Down"): direction += 1

	velocity.y = direction * speed
	move_and_slide()

	# Clamp Y position to screen
	var screen_height = get_viewport_rect().size.y
	position.y = clamp(position.y, 0, screen_height)
	

func _shoot():
	print("UwU")
