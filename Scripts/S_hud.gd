class_name HUD extends CanvasLayer

@export var player: Node
@export var LifeLabel : Label
@export var TimerLabel : Label

@onready var RefreshTimer = $Timer
@onready var lowLifeAudio = $LowLifeAudio

var IsCar : bool = false
var IsShip : bool = false
var IsPlatformer : bool = false

func _ready() -> void:

	if(player is CarController):
		print((CarController.lives - player.deaths))
		LifeLabel.text = "Life : " + str((CarController.lives - player.deaths))
		player.hp_changed.connect(on_hp_changed)
		IsCar = true
	else:
		if(player is ShooterController):
			print((ShooterController.lives - player.deaths))
			LifeLabel.text = "Life : " + str((ShooterController.lives - player.deaths))
			player.hp_changed.connect(on_hp_changed)
			IsShip = true
		else:
			if(player is PlatformerController):
				print((PlatformerController.lives - player.deaths))
				LifeLabel.text = "Life : " + str((PlatformerController.lives - player.deaths))
				player.hp_changed.connect(on_hp_changed)
				IsPlatformer = true

func _process(delta: float) -> void:
	if(player && player is not PlatformerController):
		var TimeFloor: int = int(round(player.leveltimer.time_left))
		TimerLabel.text = "Time : " + str(TimeFloor)
	
	if player.deaths == CarController.lives - 1:
		var access_menu = GameSingletons.get_node("MenuLayer/CenterContainer/TabContainer/ACCESSIBILITY")
		if not lowLifeAudio.playing:
			if access_menu.low_life_mode:
				lowLifeAudio.play()
		else:
			if not access_menu.low_life_mode:
				lowLifeAudio.stop()
	

func on_hp_changed():
	print("life debug : ")
	LifeLabel.text = "Life : " + str((CarController.lives - player.deaths))

func _on_timer_timeout() -> void:
	#TimerLabel.text = "Time : " + str(player.LevelTime)
	pass # Replace with function body.

func _on_low_life_audio_finished() -> void:
	var access_menu = GameSingletons.get_node("MenuLayer/CenterContainer/TabContainer/ACCESSIBILITY")
	if access_menu.low_life_mode:
		lowLifeAudio.play()
	else:
		lowLifeAudio.stop()
