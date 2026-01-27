extends AnimatableBody2D

@export var player : CharacterBody2D

var original_pos_x
var new_pos_x

func _ready() -> void:
	original_pos_x = player.global_position.x
	new_pos_x = original_pos_x

func _physics_process(delta: float) -> void:
	new_pos_x =  player.global_position.x
	if new_pos_x > original_pos_x:
		position.x += (new_pos_x - original_pos_x) - 0.475 #offset IDK why ; _ ;
		original_pos_x = new_pos_x
