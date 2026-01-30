class_name ShooterController extends CharacterBody2D

@export var bullet_prefab : PackedScene
@export var speed: float = 500.0

signal hp_changed()

static var lives: int = 3
static var OneButton: bool = false
static var LevelTime: float = 40
static var reload_time : float = 1

var deaths: int = 0
var isdead: bool = false
var canDie: bool = true

@onready var timer = $Timer
@onready var MeshColor = $MeshInstance2D
@onready var shootAudio = $fireAudio
@onready var engineAudio = $engineAudio
@onready var leveltimer = $Timer2

var auto_shoot: bool = false
var can_shoot := true

func _ready():
	leveltimer.stop()
	leveltimer.wait_time = LevelTime
	leveltimer.start()

func _physics_process(delta):
	if deaths == lives && canDie: 
		gameover()

	if isdead == true: 
		diestate(delta)
		return
	
	if Input.is_action_pressed("Action") and can_shoot and !auto_shoot: _shoot()
	else: if can_shoot and auto_shoot: _shoot()
	
	# Movements
	var direction_y := 0.0
	var direction_x := 0.0
	if isdead == false && OneButton == false:
		if Input.is_action_pressed("Move_Up"): direction_y -= 1
		if Input.is_action_pressed("Move_Down"): direction_y += 1
		if Input.is_action_pressed("Move_Left"): direction_x -= 1
		if Input.is_action_pressed("Move_Left"): direction_x -= 1
		if Input.is_action_pressed("Move_Right"): direction_x += 1

	if isdead == false && OneButton == true:
		if!(Input.is_action_pressed("Move_Down")):
			direction_y -= 1
		if Input.is_action_pressed("Move_Down"): direction_y += 1
		if can_shoot: _shoot()

	var direction = Vector2(direction_x, direction_y).normalized()
	#velocity = direction * speed

	velocity = lerp(velocity, direction.normalized() * speed, 0.1)
	move_and_slide()

	# Clamp position to screen
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _shoot():
	shootAudio.play_random()
	can_shoot = false

	var bullet = bullet_prefab.instantiate()
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)
	
	await get_tree().create_timer(reload_time).timeout
	can_shoot = true

func die():
	if(isdead == false):
		deaths += 1
		hp_changed.emit()
	isdead = true
	timer.start()
	print("life : ", lives - deaths)

func diestate(delta):
	#MeshColor.modulate(Color.RED)
	can_shoot = false
	MeshColor.rotate(20 * delta)

func gameover():
	GameSingletons.get_node("GameOverSound").play()
	queue_free()
	print("gameover")

func _on_timer_timeout() -> void:
	isdead = false
	MeshColor.rotation = 0
	can_shoot = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	die()

func _on_engine_audio_finished() -> void:
	engineAudio.play()

func end_of_level_timeout() -> void:
	GameManager.swapScene(GameManager.current_index +1)
