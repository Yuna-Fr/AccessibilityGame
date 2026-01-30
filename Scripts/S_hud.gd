class_name HUD extends CanvasLayer

@export var player: Node
@export var LifeLabel : Label
@export var TimerLabel : Label

@onready var RefreshTimer = $Timer

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

func on_hp_changed():
	print("life debug : ")
	LifeLabel.text = "Life : " + str((CarController.lives - player.deaths))

func _on_timer_timeout() -> void:
	#TimerLabel.text = "Time : " + str(player.LevelTime)
	pass
