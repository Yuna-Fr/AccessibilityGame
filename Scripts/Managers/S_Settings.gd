extends MarginContainer

@export var easy : Button
@export var normal : Button
@export var hard : Button

@export_group("Car")
@export var c_one_button : CheckBox

@export_group("Shooter")
@export var s_one_button : CheckBox

@export_group("Platformer")
@export var p_one_button : CheckBox
@export var p_helper : CheckBox

#region Color Modes
@export_group("Default Colors")
@export var default_bg : Color
@export var default_forest : Color
@export var default_road : Color
@export var default_sea : Color
@export var default_platformer : Color

@export_group("Daltonism aka Maxime Mode")
@export var d_player : ColorPickerButton
@export var d_bullet : ColorPickerButton
@export var d_enemy : ColorPickerButton

@export_group("Contrast Mode")
@export var contrast_mode : CheckBox
@export var co_bg : Color
@export var co_forest : Color
@export var co_road : Color
@export var co_sea : Color
@export var co_platformer : Color

#endregion

@export var low_life_mode = false


func _ready():
	reset_colors_to_default()
	
	# Buttons connection
	easy.pressed.connect(difficulty_easy)
	normal.pressed.connect(difficulty_normal)
	hard.pressed.connect(difficulty_hard)
	
	c_one_button.toggled.connect(c_toggle_one_button)
	s_one_button.toggled.connect(s_toggle_one_button)
	p_one_button.toggled.connect(p_toggle_one_button)
	p_helper.toggled.connect(p_toggle_helper_blocks)
	
	d_player.color_changed.connect(player_color)
	d_bullet.color_changed.connect(bullet_color)
	d_enemy.color_changed.connect(enemy_color)
	contrast_mode.toggled.connect(toggle_contrast_mode)
	

func difficulty_easy(): 
	CarController.lives = 10
	ShooterController.lives = 10
	PlatformerController.lives = 10
	
	Spawner.spawn_interval = 3.0
	
	
	var node := get_tree().get_root().find_child("MajorTom", true, false)
	if node is HUD:
		node.on_hp_changed()
	
func difficulty_normal(): 
	CarController.lives = 3
	ShooterController.lives = 3
	PlatformerController.lives = 3
	#CarController.leveltime
	
	Spawner.spawn_interval = 2.0
	
	var node := get_tree().get_root().find_child("MajorTom", true, false)
	if node is HUD:
		node.on_hp_changed()

func difficulty_hard(): 
	CarController.lives = 1
	ShooterController.lives = 1
	PlatformerController.lives = 1
	
	Spawner.spawn_interval = 1.0
	
	var node := get_tree().get_root().find_child("MajorTom", true, false)
	if node is HUD:
		node.on_hp_changed()

#region Car
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

func p_toggle_helper_blocks(toggled : bool): 
	A11yBlocks.AccessibilityBlocks = toggled
#endregion

#region Color Modes

func player_color(color: Color):
	RenderingServer.global_shader_parameter_set("PlayerColorParameter", color)

func bullet_color(color: Color):
	RenderingServer.global_shader_parameter_set("BulletColorParameter", color)

func enemy_color(color: Color):
	RenderingServer.global_shader_parameter_set("EnnemyColorParameter", color)

func toggle_contrast_mode(toggled : bool):
	if !toggled :
		reset_colors_to_default()
		return
	
	RenderingServer.global_shader_parameter_set("BackgroundColorParameter", co_bg)
	RenderingServer.global_shader_parameter_set("BackgroundForestColorParameter", co_forest)
	RenderingServer.global_shader_parameter_set("BackgroundRoadColorParameter", co_road)
	RenderingServer.global_shader_parameter_set("BackgroundSeaColorParameter", co_sea)
	RenderingServer.global_shader_parameter_set("LevelPlatformerColorParameter", co_platformer)

func reset_colors_to_default():
	RenderingServer.global_shader_parameter_set("BackgroundColorParameter", default_bg)
	RenderingServer.global_shader_parameter_set("BackgroundForestColorParameter", default_forest)
	RenderingServer.global_shader_parameter_set("BackgroundRoadColorParameter", default_road)
	RenderingServer.global_shader_parameter_set("BackgroundSeaColorParameter", default_sea)
	RenderingServer.global_shader_parameter_set("LevelPlatformerColorParameter", default_platformer)
#endregion


func set_global_font_size(size: int) -> void:
	var g_theme := ThemeDB.get_default_theme()
	g_theme.set_default_font_size(size)

func _on_txt_scale_spin_box_value_changed(value: float) -> void:
	set_global_font_size(value)

func change_volume(bus:String, value:float):
	var bus_index= AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_linear(bus_index, value/100) # value between 0 and 1 if divided by 100


func _on_music_slider_value_changed(value: float) -> void:
	change_volume("Music", value)

func _on_sfx_slider_value_changed(value: float) -> void:
	change_volume("SFX", value)

func _on_low_life_sound_toggled(toggled_on: bool) -> void:
	low_life_mode = toggled_on
