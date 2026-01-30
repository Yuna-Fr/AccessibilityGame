extends MarginContainer

@export_group("Car")
@export var c_one_button : CheckBox

@export_group("Shooter")
@export var s_one_button : CheckBox

@export_group("Platformer")
@export var p_one_button : CheckBox

#region Color Modes
@export_group("Default Colors")
@export var default_bg : Color
@export var default_forest : Color
@export var default_road : Color
@export var default_sea : Color
@export var default_bullet : Color
@export var default_enemy : Color
@export var default_platformer : Color
@export var default_player : Color

@export_group("Daltonism aka Maxime Mode")
@export var daltonism_mode : CheckBox
@export var d_bg : Color
@export var d_forest : Color
@export var d_road : Color
@export var d_sea : Color
@export var d_bullet : Color
@export var d_enemy : Color
@export var d_platformer : Color
@export var d_player : Color

@export_group("Contrast Mode")
@export var contrast_mode : CheckBox
@export var co_bg : Color
@export var co_forest : Color
@export var co_road : Color
@export var co_sea : Color
@export var co_bullet : Color
@export var co_enemy : Color
@export var co_platformer : Color
@export var co_player : Color

#endregion

func _ready():
	reset_colors_to_default()
	
	# Buttons connection
	c_one_button.toggled.connect(c_toggle_one_button)
	s_one_button.toggled.connect(s_toggle_one_button)
	p_one_button.toggled.connect(p_toggle_one_button)
	
	daltonism_mode.toggled.connect(toggle_daltonism_mode)
	contrast_mode.toggled.connect(toggle_contrast_mode)

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

#region Color Modes
func toggle_daltonism_mode(toggled : bool):
	if !toggled :
		reset_colors_to_default()
		return
	
	RenderingServer.global_shader_parameter_set("BackgroundColorParameter", d_bg)
	RenderingServer.global_shader_parameter_set("BackgroundForestColorParameter", d_forest)
	RenderingServer.global_shader_parameter_set("BackgroundRoadColorParameter", d_road)
	RenderingServer.global_shader_parameter_set("BackgroundSeaColorParameter", d_sea)
	RenderingServer.global_shader_parameter_set("BulletColorParameter", d_bullet)
	RenderingServer.global_shader_parameter_set("EnnemyColorParameter", d_enemy)
	RenderingServer.global_shader_parameter_set("LevelPlatformerColorParameter", d_platformer)
	RenderingServer.global_shader_parameter_set("PlayerColorParameter", d_player)
	
func toggle_contrast_mode(toggled : bool):
	if !toggled :
		reset_colors_to_default()
		return
	
	RenderingServer.global_shader_parameter_set("BackgroundColorParameter", co_bg)
	RenderingServer.global_shader_parameter_set("BackgroundForestColorParameter", co_forest)
	RenderingServer.global_shader_parameter_set("BackgroundRoadColorParameter", co_road)
	RenderingServer.global_shader_parameter_set("BackgroundSeaColorParameter", co_sea)
	RenderingServer.global_shader_parameter_set("BulletColorParameter", co_bullet)
	RenderingServer.global_shader_parameter_set("EnnemyColorParameter", co_enemy)
	RenderingServer.global_shader_parameter_set("LevelPlatformerColorParameter", co_platformer)
	RenderingServer.global_shader_parameter_set("PlayerColorParameter", co_player)

func reset_colors_to_default():
	RenderingServer.global_shader_parameter_set("BackgroundColorParameter", default_bg)
	RenderingServer.global_shader_parameter_set("BackgroundForestColorParameter", default_forest)
	RenderingServer.global_shader_parameter_set("BackgroundRoadColorParameter", default_road)
	RenderingServer.global_shader_parameter_set("BackgroundSeaColorParameter", default_sea)
	RenderingServer.global_shader_parameter_set("BulletColorParameter", default_bullet)
	RenderingServer.global_shader_parameter_set("EnnemyColorParameter", default_enemy)
	RenderingServer.global_shader_parameter_set("LevelPlatformerColorParameter", default_platformer)
	RenderingServer.global_shader_parameter_set("PlayerColorParameter", default_player)
#endregion
