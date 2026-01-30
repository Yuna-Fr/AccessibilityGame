class_name CarController extends CharacterBody2D

@export var speed: float = 500.0

static var lives: int = 3

var deaths: int = 0
var isdead: bool = false
var canDie: bool = true
static var OneButton: bool = false
static var LevelTime: float = 40

signal hp_changed()

@onready var timer = $Timer
@onready var MeshColor = $MeshInstance2D
@onready var engineAudio = $engineAudio
@onready var crashAudio = $crashAudio
@onready var leveltimer = $Timer2


func _ready():
	leveltimer.stop()
	leveltimer.wait_time = LevelTime
	leveltimer.start()
	pass

func _physics_process(delta):
	var direction := 0.0
	
	if deaths >= lives && canDie:
		gameover()
	
	if isdead == true:
		diestate(delta)
	
	if isdead == false && OneButton == false:
		if Input.is_action_pressed("Move_Up"): direction -= 1
		if Input.is_action_pressed("Move_Down"): direction += 1
		
	if isdead == false && OneButton == true:
		if!(Input.is_action_pressed("Move_Down")):
			direction -= 1
		if Input.is_action_pressed("Move_Down"): direction += 1


	velocity.y = lerp(velocity.y, direction * speed, 0.1)
	move_and_slide()

	# Clamp Y position to screen
	var screen_height = get_viewport_rect().size.y -80
	position.y = clamp(position.y, 80, screen_height)


func _on_area_2d_area_entered(area: Area2D) -> void:
	die()
	pass # Replace with function body.

func die():
	if(isdead == false):
		deaths += 1
		hp_changed.emit()
	isdead = true
	timer.start()
	print("life : ", (lives - deaths))
	

func diestate(delta):
	#MeshColor.modulate(Color.RED)
	MeshColor.rotate(20 * delta)
	if not crashAudio.playing:
		crashAudio.play_random()

func gameover():
	GameSingletons.get_node("GameOverSound").play()
	queue_free()
	print("gameover")
	pass

func _on_timer_timeout() -> void:
	isdead = false
	MeshColor.rotation = 0


func _on_engine_audio_finished() -> void:
	engineAudio.play()

func end_of_level_timeout() -> void:
	GameManager.swapScene(GameManager.current_index +1)
