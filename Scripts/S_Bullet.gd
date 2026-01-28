extends Area2D

@export var speed: float = 800
@export var size: float = 1

func _ready() -> void:
	scale = scale * size
	pass

func _physics_process(delta):
		position.x += speed * delta



func _on_area_entered(area: Area2D) -> void:
	queue_free()
	pass # Replace with function body.
