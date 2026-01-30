extends Control

@export var first_level : PackedScene
@export var startButton : Button

var optionUI

func _ready() -> void:
	startButton.grab_focus.call_deferred()
	optionUI = GameSingletons.get_node("MenuLayer")
	optionUI.unpauseFocusControl = startButton

func _on_start_pressed() -> void:
	optionUI.visible = false
	optionUI.unpauseFocusControl = null
	get_tree().change_scene_to_packed(first_level)


func _on_options_pressed() -> void:
	optionUI.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
