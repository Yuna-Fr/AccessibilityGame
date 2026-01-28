extends Area2D

@export var speed: float = 200
var ismoving: bool = false

@export var texturelist: Array[Texture]

@onready var sprite = $Sprite2D

func _ready():
	ismoving = true
	sprite.texture = texturelist.pick_random()
	
func _physics_process(delta):
	move_local_x(-speed * delta)

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	print("bouffon")

func _on_area_entered(body: Area2D) -> void:
	queue_free()
