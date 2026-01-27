extends CharacterBody2D

@export var speed : float = 50
@export var jump_speed : float = 500
@export var gravity : float = 9.98
@export var friction : float = 30
@export var air_friction : float = 5


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * 5
		if velocity.x > 0:
			velocity.x -= air_friction
		elif velocity.x < 0:
			velocity.x += air_friction
		else:
			velocity.x = 0
		
	else:
		velocity.y = 3
	
	if Input.is_action_pressed("Move_Left"):
		velocity.x -= speed
	if Input.is_action_pressed("Move_Right"):
		velocity.x += speed
		
	if is_on_floor():
		if Input.is_action_just_pressed("Move_Up"):
			velocity.y = -jump_speed * 2
		
	if velocity.x > 0:
		velocity.x -= friction
	elif velocity.x < 0:
		velocity.x += friction
	else:
		velocity.x = 0
	
	move_and_slide()
