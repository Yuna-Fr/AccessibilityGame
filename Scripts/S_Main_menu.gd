extends Control

@export var first_level : PackedScene

var optionUI

func _ready() -> void:
	
	optionUI = GameSingletons.get_node("MenuLayer")

func _on_start_pressed() -> void:
	optionUI.visible = false
	get_tree().change_scene_to_packed(first_level)


func _on_options_pressed() -> void:
	optionUI.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
