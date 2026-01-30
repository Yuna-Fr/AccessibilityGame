extends CanvasLayer

@export var music : AudioStreamPlayer

var paused = false

func _ready() -> void:
	self.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		paused = !paused
		self.visible = paused
		get_tree().paused = paused

func _on_exit_button_pressed() -> void:
	paused = false
	self.visible = false
	get_tree().paused = false

func _on_music_finished() -> void:
	if music.stream != null:
		music.play()
