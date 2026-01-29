extends MarginContainer

@export_category("Shooter")
@export var s_one_button : CheckBox

@export_category("Platformer")
@export var p_one_button : CheckBox

func _ready():
	s_one_button.toggled.connect(s_toggle_one_button)
	p_one_button.toggled.connect(p_toggle_one_button)

#region Shooter
func s_toggle_one_button(toggled : bool): 
	ShooterController.OneButton = toggled

#endregion

#region Platformer
func p_toggle_one_button(toggled : bool): 
	PlatformerController.OneButton = toggled

#endregion
