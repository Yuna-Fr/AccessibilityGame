extends CanvasLayer

@export var player: Node

@export var LifeLabel : Label

@export var TimerLabel : Label

@onready var RefreshTimer = $Timer

var IsCar : bool = false
var IsShip : bool = false
var IsPlatformer : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if(player is CarController):
		print(player.life)
		LifeLabel.text = "Life : " + str(player.life)
		player.hp_changed.connect(on_hp_changed)
		IsCar = true
	else:
		if(player is ShooterController):
			print(player.life)
			LifeLabel.text = "Life : " + str(player.life)
			player.hp_changed.connect(on_hp_changed)
			IsShip = true
		else:
			if(player is PlatformerController):
				print(player.life)
				LifeLabel.text = "Life : " + str(player.life)
				player.hp_changed.connect(on_hp_changed)
				IsPlatformer = true

	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(player is not PlatformerController):
		var TimeFloor: int = int(round(player.leveltimer.time_left))
		TimerLabel.text = "Time : " + str(TimeFloor)
	pass
	

func on_hp_changed():
	print("life debug : ")
	LifeLabel.text = "Life : " + str(player.life)
	pass


func _on_timer_timeout() -> void:
	#TimerLabel.text = "Time : " + str(player.LevelTime)
	pass # Replace with function body.
