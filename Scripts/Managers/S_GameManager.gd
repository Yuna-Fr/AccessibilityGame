class_name S_GameManager extends Node

static var instance : S_GameManager

@export var scene : Array[PackedScene]

var current_index : int = 0
var current_scene : Node
	
func _ready() -> void:
	instance = self
	#swapScene(0)

func _physics_process(delta):
	if Input.is_action_just_released("SwapScene"):
		if (current_index + 1) < scene.size():
			swapScene(current_index + 1)
		else:
			swapScene(0)
		
func swapScene(scene_index: int):
	if scene_index < 0 or scene_index >= scene.size():
		push_warning("Scene index out of range")
		return

	#if current_scene: current_scene.queue_free()

	current_index = scene_index
	#current_scene = scene[scene_index].instantiate()
	#add_child(current_scene)
	get_tree().change_scene_to_packed(scene[scene_index])
