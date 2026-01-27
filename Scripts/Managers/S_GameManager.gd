class_name S_GameManager extends Node

@export var scene : Array[PackedScene]

var current_scene : Node
	
func swapScene(scene_index: int):
	if scene_index < 0 or scene_index >= scene.size():
		push_warning("Scene index out of range")
		return

	if current_scene: current_scene.queue_free()

	current_scene = scene[scene_index].instantiate()
	add_child(current_scene)
