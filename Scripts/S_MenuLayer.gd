extends CanvasLayer

var paused = false

func _ready() -> void:
	self.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		paused = !paused
		self.visible = paused
		get_tree().paused = paused
