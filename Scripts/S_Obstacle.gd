extends Area2D
class_name Obstacle

@export var speed: float = 200
var ismoving: bool = false
var isHit: bool = false


@export var texturelist: Array[Texture]

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var crashAudio = $CrashAudio

var life = 1

func _ready():
	ismoving = true
	sprite.texture = texturelist.pick_random()



func _physics_process(delta):
	move_local_x(-speed * delta)
	
	if isHit == true:
		diestate(delta)
		print("blabla")
	
	if(life == 0):
		die()
	

func _on_body_entered(body: Node2D) -> void:
	crashAudio.play_random()
	crashAudio.reparent(get_tree().current_scene)
	queue_free()
	print("bouffon")

func _on_area_entered(body: Area2D) -> void:
	crashAudio.play_random()
	isHit = true
	timer.start()
	life -=1
	

func diestate(delta):
	sprite.rotate(5 * delta)
	pass

func die():
	crashAudio.play_random()
	crashAudio.reparent(get_tree().current_scene)
	queue_free()

func setHp(hp: int):
	life = hp
	pass


func _on_timer_timeout() -> void:
	isHit = false
	sprite.rotation_degrees = -90
	pass # Replace with function body.
