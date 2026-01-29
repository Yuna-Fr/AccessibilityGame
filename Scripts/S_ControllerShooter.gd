class_name ControllerShooter extends CharacterBody2D

@export var bullet_prefab : PackedScene
@export var speed: float = 500.0
@export var reload_time : float = 1

#Variables communes
@export var life: int = 3
var isdead: bool = false
var canDie: bool = true

@onready var timer = $Timer
@onready var MeshColor = $MeshInstance2D

var can_shoot := true

func _physics_process(delta):
	if life==0 && canDie: 
		gameover()

	if isdead == true: 
		diestate(delta)
		return
	
	if Input.is_action_pressed("Action") and can_shoot: 
		_shoot()
	
	# Movements
	var direction := Vector2(
		Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left"),
		Input.get_action_strength("Move_Down") - Input.get_action_strength("Move_Up"))

	velocity = direction.normalized() * speed
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

func die():
	if(isdead == false):
		life -= 1
	isdead = true
	timer.start()
	print("life : ", life)

func diestate(delta):
	#MeshColor.modulate(Color.RED)
	can_shoot = false
	MeshColor.rotate(20 * delta)

func gameover():
	queue_free()
	print("gameover")
	pass

func _on_timer_timeout() -> void:
	isdead = false
	MeshColor.rotation = 0
	can_shoot = true
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	die()
	pass # Replace with function body.
