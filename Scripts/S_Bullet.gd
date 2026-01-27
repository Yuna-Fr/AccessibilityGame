extends Area2D

@export var speed: float = 200

var ismoving: bool = false

func _ready():
	ismoving = true
	
func _physics_process(delta):
	move_local_x(speed * delta)

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	print("bouffon")
