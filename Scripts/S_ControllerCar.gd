class_name ControllerCar extends CharacterBody2D

@export var speed: float = 500.0
@export var life: int = 3
var isdead: bool = false
var candie: bool = true
@onready var timer = $Timer
@onready var MeshColor = $MeshInstance2D

func _ready():
	pass

func _physics_process(delta):
	var direction := 0.0
	
	if life==0 && candie:
		gameover()
	
	if isdead == true:
		diestate(delta)
	
	if isdead == false:
		if Input.is_action_pressed("Move_Up"): direction -= 1
		if Input.is_action_pressed("Move_Down"): direction += 1

	velocity.y = direction * speed
	move_and_slide()

	# Clamp Y position to screen
	var screen_height = get_viewport_rect().size.y
	position.y = clamp(position.y, 0, screen_height)


func _on_area_2d_area_entered(area: Area2D) -> void:
	die()
	pass # Replace with function body.

func die():
	isdead = true
	timer.start()
	life -= 1
	print("life : ", life)
	

func diestate(delta):
	#MeshColor.modulate(Color.RED)
	MeshColor.rotate(20 * delta)

func gameover():
	queue_free()
	print("gameover")
	pass

func _on_timer_timeout() -> void:
	isdead = false
	pass # Replace with function body.
