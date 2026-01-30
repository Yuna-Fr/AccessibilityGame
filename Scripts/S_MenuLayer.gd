extends CanvasLayer

@export var music : AudioStreamPlayer
@export var firstFocusControl : Control

var unpauseFocusControl : Control
var paused = false

func _ready() -> void:
	self.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		firstFocusControl.grab_focus.call_deferred()
		paused = !paused
		self.visible = paused
		get_tree().paused = paused
		if self.visible == false and unpauseFocusControl != null:
			unpauseFocusControl.grab_focus.call_deferred()

func _on_exit_button_pressed() -> void:
	paused = false
	self.visible = false
	get_tree().paused = false
	if unpauseFocusControl != null:
		unpauseFocusControl.grab_focus.call_deferred()

func _on_music_finished() -> void:
	if music.stream != null:
		music.play()
