class_name CarController extends CharacterBody2D

@export var speed: float = 500.0
@export var life: int = 3
var isdead: bool = false
var canDie: bool = true
static var OneButton: bool = false

@onready var timer = $Timer
@onready var MeshColor = $MeshInstance2D
@onready var engineAudio = $engineAudio
@onready var crashAudio = $crashAudio

func _ready():
	pass

func _physics_process(delta):
	var direction := 0.0
	
	if life==0 && canDie:
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


	velocity.y = direction * speed
	move_and_slide()

	# Clamp Y position to screen
	var screen_height = get_viewport_rect().size.y -80
	position.y = clamp(position.y, 80, screen_height)


func _on_area_2d_area_entered(area: Area2D) -> void:
	die()
	pass # Replace with function body.

func die():
	if(isdead == false):
		life -= 1
	isdead = true
	timer.start()
	print("life : ", life)
	

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
	pass # Replace with function body.


func _on_engine_audio_finished() -> void:
	engineAudio.play()
