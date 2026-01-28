extends Node2D


@export var prefab: PackedScene
@export var spawn_interval := 2.0
@export var spawn_x := 1200.0 # hors écran à droite (exemple)

var screen_height: float

func _ready():
	screen_height = get_viewport_rect().size.y -150
	
	var timer = $Timer
	timer.wait_time = spawn_interval
	timer.timeout.connect(_spawn)
	timer.start()

func _spawn():
	if prefab == null:
		return
	
	var instance = prefab.instantiate()
	
	var random_y = randf_range(0, screen_height)
	instance.position = Vector2(spawn_x, random_y)
	
	add_child(instance)
