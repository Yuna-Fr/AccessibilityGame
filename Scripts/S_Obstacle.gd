extends Area2D
class_name Obstacle

@export var speed: float = 200
var ismoving: bool = false

@export var texturelist: Array[Texture]

@onready var sprite = $Sprite2D

var life = 1

func _ready():
	ismoving = true
	sprite.texture = texturelist.pick_random()



func _physics_process(delta):
	move_local_x(-speed * delta)
	
	if(life == 0):
		die()
	

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	print("bouffon")

func _on_area_entered(body: Area2D) -> void:
	life -=1

func die():
	queue_free()

func setHp(hp: int):
	life = hp
	pass
