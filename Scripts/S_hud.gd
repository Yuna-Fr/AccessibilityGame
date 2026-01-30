extends CanvasLayer

@export var player: Node

@export var LifeLabel : Label
@export var LifeBar : ProgressBar

@export var TimerLabel : Label

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
	
	
	
	pass
	

func on_hp_changed():
	print("life debug : ")
	LifeLabel.text = "Life : " + str(player.life)
	pass
