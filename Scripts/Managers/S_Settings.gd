extends MarginContainer

@export_group("Car")
@export var c_one_button : CheckBox

@export_group("Shooter")
@export var s_one_button : CheckBox

@export_group("Platformer")
@export var p_one_button : CheckBox

@export var daltonism_mode : CheckBox

func _ready():
	c_one_button.toggled.connect(c_toggle_one_button)
	s_one_button.toggled.connect(s_toggle_one_button)
	p_one_button.toggled.connect(p_toggle_one_button)
	
	daltonism_mode.toggled.connect(toggle_daltonism_mode)

#region Shooter
func c_toggle_one_button(toggled : bool): 
	CarController.OneButton = toggled

#endregion

#region Shooter
func s_toggle_one_button(toggled : bool): 
	ShooterController.OneButton = toggled

#endregion

#region Platformer
func p_toggle_one_button(toggled : bool): 
	PlatformerController.OneButton = toggled

#endregion

#region Other
func toggle_daltonism_mode(toggled : bool):
	#sget_instance_shader_parameter()
	pass

#endregion
