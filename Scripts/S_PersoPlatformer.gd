extends CharacterBody2D

@export var speed : float = 50
@export var jump_speed : float = 500
@export var gravity : float = 9.98
@export var friction : float = 30
@export var air_friction : float = 5
var canDie: bool = true

@onready var cam = $Camera2D
@onready var soundGround = $SonsCollisionSol
@onready var timer = $Timer
@onready var jumpSound = $SonSaut
@export var respawnpoint : Node2D

#Variables communes
@export var life: int = 3
#

var original_pos_x
var new_pos_x
var toggle_ground:bool # a toggle when ground is hit (to triggered once per collision)

func _ready() -> void:
	#original_pos_x = self.global_position.x
	#new_pos_x = original_pos_x
	#print(get_viewport().get_visible_rect().size)
	#cam.limit_left = get_viewport().get_visible_rect().size.x
	#cam.limit_left = 0
	pass

func _physics_process(delta: float) -> void:
	#new_pos_x =  self.global_position.x
	#if new_pos_x > original_pos_x:
	#	cam.limit_left += new_pos_x - original_pos_x
	#	original_pos_x = new_pos_x

	if life==0 && canDie:
		gameover()

	if not is_on_floor():
		if toggle_ground:
			toggle_ground = false
		
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
		if not toggle_ground:
			toggle_ground = !toggle_ground
			soundGround.play_random()
		
		if Input.is_action_just_pressed("Action"):
			jumpSound.play_random()
			velocity.y = -jump_speed * 2
		
	if velocity.x > 0:
		velocity.x -= friction
	elif velocity.x < 0:
		velocity.x += friction
	else:
		velocity.x = 0
	
	move_and_slide()




func _on_timer_timeout() -> void:
	position = respawnpoint.position
	life -= 1

	
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	timer.start()
	print("tombé")
	pass # Replace with function body.

func gameover():
	queue_free()
	print("gameover")
