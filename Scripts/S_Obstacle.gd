extends Area2D
class_name Obstacle

@export var speed: float = 200
var ismoving: bool = false
var isHit: bool = false


@export var texturelist: Array[Texture]

@onready var sprite = $Sprite2D
@onready var timer = $Timer

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
	queue_free()
	print("bouffon")

func _on_area_entered(body: Area2D) -> void:
	isHit = true
	timer.start()
	life -=1
	

func diestate(delta):
	sprite.rotate(5 * delta)
	sprite.self_modulate(1,1,1,1*delta)
	pass

func die():
	queue_free()

func setHp(hp: int):
	life = hp
	pass


func _on_timer_timeout() -> void:
	isHit = false
	sprite.rotation_degrees = -90
	pass # Replace with function body.
