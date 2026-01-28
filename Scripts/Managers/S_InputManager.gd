extends Control

const CONFIG_PATH := "user://keybindings.cfg"

const REBINDABLE_ACTIONS := [
	"Move_Up",
	"Move_Down",
	"Move_Left",
	"Move_Right",
	"Action"
]

@export var move_up_btn : Button
@export var move_down_btn : Button
@export var move_left_btn : Button
@export var move_right_btn : Button
@export var action_btn : Button
@export var reset_btn : Button
@export var finish_btn : Button

var waiting_for_input := false
var action_to_rebind := ""

func _ready():
	load_bindings()
	update_button_labels()
	
	move_up_btn.pressed.connect(func(): start_rebind("Move_Up"))
	move_down_btn.pressed.connect(func(): start_rebind("Move_Down"))
	move_left_btn.pressed.connect(func(): start_rebind("Move_Left"))
	move_right_btn.pressed.connect(func(): start_rebind("Move_Right"))
	action_btn.pressed.connect(func(): start_rebind("Action"))
	reset_btn.pressed.connect(func(): reset_bindings())
	finish_btn.pressed.connect(func(): finish())

func finish():
	self.visible = false

func getButton(action: String) -> Button :
	if action == "Move_Up" : return move_up_btn
	if action == "Move_Down" : return move_down_btn
	if action == "Move_Left" : return move_left_btn
	if action == "Move_Right" : return move_right_btn
	if action == "Action" : return action_btn
	return null

#region Input Capture and Rebinding

func _input(event):
	if not waiting_for_input: return
	
	if event is InputEventKey and event.pressed:
		rebind_action(action_to_rebind, event)
		waiting_for_input = false
		action_to_rebind = ""

func start_rebind(action: String):
	waiting_for_input = true
	action_to_rebind = action

func rebind_action(action: String, event: InputEventKey):
	for _action in REBINDABLE_ACTIONS:
		if _action == action: 
			continue # skip the action we're rebinding
		for ev in InputMap.action_get_events(_action):
			if ev is InputEventKey and ev.keycode == event.keycode:
				InputMap.action_erase_event(_action, ev)
				##TODO : make button red with getButton(action)
				print("Removed duplicate key from: ", _action)

	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			InputMap.action_erase_event(action, ev)

	var new_event := InputEventKey.new()
	new_event.keycode = event.keycode
	InputMap.action_add_event(action, new_event)

	update_button_labels()
	save_bindings()

func update_button_labels():
	move_up_btn.text = "Move Up: " + get_action_key("Move_Up")
	move_down_btn.text = "Move Down: " + get_action_key("Move_Down")
	move_left_btn.text = "Move Left: " + get_action_key("Move_Left")
	move_right_btn.text = "Move Right: " + get_action_key("Move_Right")
	action_btn.text = "Shoot / Jump: " + get_action_key("Action")

func get_action_key(action: String) -> String:
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			return ev.as_text()
	return "Unassigned"

func reset_bindings():
	InputMap.load_from_project_settings()

	# remove saved bindings file
	if FileAccess.file_exists(CONFIG_PATH):
		DirAccess.remove_absolute(CONFIG_PATH)

	waiting_for_input = false
	action_to_rebind = ""

	update_button_labels()

#endregion

#region Saving
func save_bindings():
	var cfg := ConfigFile.new()
	
	for action in REBINDABLE_ACTIONS:
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey:
				cfg.set_value("keys", action, ev.keycode)
				break
	
	cfg.save(CONFIG_PATH)

func load_bindings():
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK: return

	for action in REBINDABLE_ACTIONS:
		if not cfg.has_section_key("keys", action):
			continue
		
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey:
				InputMap.action_erase_event(action, ev)
		
		var new_event := InputEventKey.new()
		new_event.keycode = cfg.get_value("keys", action)
		new_event.pressed = true
		
		InputMap.action_add_event(action, new_event)

#endregion

#var first_config = false
#
#var keyboard_keybinds = {}
#var inital_controls
#var original_config = {}
#
#var gamepad_keybinds = {}
#
#var joy_axis = null
#var joy_value = null
#var joy_button_index = null
#
#var start_init = true
#
#var touchscreen_play
#
#func _ready():
	#original_config = extract_original_config_data("InputEventKey")
	#
	#game_controls = ConfigFile.new()
	#if game_controls.load(controls_filepath) != OK:
		#write_first_configfile(game_controls, controls_filepath)
		#first_config = true
		##game_controls.save(controls_filepath)
		#game_controls.load(controls_filepath)
		#
	#else:
		#game_controls.load(controls_filepath)
		##print(game_controls)
	#
	#
	#OptionMenu.connect("ready", self, "initialize_game")
	#
	#
	#for key in game_controls.get_section_keys(config_section): # Extraire les infos du fichier de configuration des touches
		#controls_array_objects = game_controls.get_value(config_section, key)
		#for key_object in controls_array_objects:
			##if key_object.get("scancode") == OK:
			#var key_value = key_object.get("scancode")
			#if key_value != null:
				##print(str(key)  + ":" + str(key_value))
				#if key_value != 0:
					#keyboard_keybinds[key] = key_value
				#else:
					#keyboard_keybinds[key] = null
				#
				##print(keyboard_keybinds[key])
				##keyboard_keybinds[key] = key_value
	#
	#for joy_action in game_controls.get_section_keys(config_section): # Extraire les infos du fichier de configuration des touches
		#controls_array_objects = game_controls.get_value(config_section, joy_action)
		#for joy_object in controls_array_objects:
			##if key_object.get("scancode") == OK:
			#
			#if joy_object.get_class() == "InputEventJoypadMotion":
				#joy_axis = joy_object.get("axis")
				#joy_value = joy_object.get("axis_value")
				#if joy_axis != null and joy_value != null:
					#gamepad_keybinds[joy_action] = {"axis":joy_axis, "axis_value":joy_value}
					#if joy_axis == 777 and joy_value == 777:
						#gamepad_keybinds[joy_action] = {"axis":null, "axis_value":null}
			#elif joy_object.get_class() == "InputEventJoypadButton":
				#joy_button_index = joy_object.get("button_index")
				#if joy_button_index != null:
					#gamepad_keybinds[joy_action] = {"button_index":joy_button_index}
					#if joy_button_index == 777:
						#gamepad_keybinds[joy_action] = {"button_index":null}
			#
			##print(gamepad_keybinds)
##			print(str(joy_axis))
##			print(str(joy_value))
##			print(str(joy_button_index) + "\n")
			#
			#
##			if joy_axis != null:
##				#print(str(joy_action)  + ":" + str(joy_value))
##				if joy_axis != 0:
##					gamepad_keybinds[joy_action] = joy_axis
##				else:
##					gamepad_keybinds[joy_action] = null
	#
	#change_keyboard_keybinds()
	#change_gamepad_keybinds()
#
#func initialize_game():
	#if first_config:
		#OptionMenu.save_settings()
		#first_config = false
		#
	#OptionMenu.load_settings()
	#
	#OptionMenu.queue_free()
#
#func write_first_configfile(config_file, filepath):
	#config_file = ConfigFile.new()
	#for action in InputMap.get_actions():
		#if configurable_controls.has(action):
			#inital_controls = InputMap.get_action_list(action)
			#config_file.set_value(config_section, action, inital_controls)
			#config_file.save(filepath)
#
#func extract_original_config_data(filter_event):
	#var dict = {}
	#for action in InputMap.get_actions():
		#if configurable_controls.has(action):
			#inital_controls = InputMap.get_action_list(action)
			#
			#for object_action in inital_controls:
				#if object_action.get_class() == filter_event:
					#var key_code = object_action.get("scancode")
					#dict[action] = key_code
	#return dict
#
#func change_keyboard_keybinds():
	#for key in keyboard_keybinds.keys():
		#var value = keyboard_keybinds[key]
		#var action_list = InputMap.get_action_list(key)
		#for object_action in action_list:
			#if object_action.get_class() is InputEventKey:
				#InputMap.action_erase_event(key, object_action)
			#
			#if value != object_action.get("scancode"):
				#var no_key = InputEventKey.new()
				#if object_action.get("scancode") != null:
					#no_key.set_scancode(object_action.get("scancode"))
				#InputMap.action_erase_event(key, no_key)
			#
			#if value != null:
				#var new_key = InputEventKey.new()
				#new_key.set_scancode(value)
				#InputMap.action_add_event(key, new_key)
#
#func change_gamepad_keybinds():
	#for key in gamepad_keybinds.keys():
		#var value = gamepad_keybinds[key]
		#var action_list = InputMap.get_action_list(key)
		#for object_action in action_list:
			#if object_action.get_class() is InputEventJoypadMotion or object_action.get_class() is InputEventJoypadButton:
				#InputMap.action_erase_event(key, object_action)
			#
			#if value != null:
				#if value.has("axis"):
					#if value["axis"] != object_action.get("axis") or value["axis_value"] != object_action.get("axis_value"):
						#var no_key = InputEventJoypadMotion.new()
						#
						#if object_action.get("axis") != null:
							#no_key.set_axis(object_action.get("axis"))
							#no_key.set_axis_value(object_action.get("axis_value"))
						#elif object_action.get("button_index") != null:
							#no_key = InputEventJoypadButton.new()
							#no_key.set_button_index(object_action.get("button_index"))
						#InputMap.action_erase_event(key, no_key)
				#elif value.has("button_index"):
					#if value["button_index"] != object_action.get("button_index"):
						#var no_key = InputEventJoypadButton.new()
						#
						#if object_action.get("button_index") != null:
							#no_key.set_button_index(object_action.get("button_index"))
						#elif object_action.get("axis") != null:
							#no_key = InputEventJoypadMotion.new()
							#no_key.set_axis(object_action.get("axis"))
							#no_key.set_axis_value(object_action.get("axis_value"))
						#InputMap.action_erase_event(key, no_key)
			#else:
				#InputMap.action_erase_event(key, object_action)
			#
			#if value != null:
				#if value.has("axis"):
					#if value["axis"] != null:
						#var new_key = InputEventJoypadMotion.new()
						#new_key.set_axis(value["axis"])
						#new_key.set_axis_value(value["axis_value"])
						#InputMap.action_add_event(key, new_key)
				#elif value.has("button_index"):
					#if value["button_index"] != null:
						#var new_key = InputEventJoypadButton.new()
						#new_key.set_button_index(value["button_index"])
						#InputMap.action_add_event(key, new_key)
		##print(InputMap.get_action_list(key))
#
#func apply_new_keyboard_keybinds(key, value):
	#keyboard_keybinds[key] = value
	#for k in keyboard_keybinds.keys():
		##print(keyboard_keybinds[k])
		##print(str(value) + "\n")
		#if k != key and value != null and keyboard_keybinds[k] == value:
			##print(keyboard_keybinds[k])
			#keyboard_keybinds[k] = null
			#OptionsNode.key_buttons[k].keyText.text = "Unassigned"
#
#func save_new_keyboard_config():
	#
	#for key in keyboard_keybinds.keys():
		#var action_list = game_controls.get_value(config_section, key)
		#var key_value = keyboard_keybinds[key]
		#
		#for object_action in action_list:
			#if object_action.get_class() == "InputEventKey":
				#if key_value != null:
					#object_action.set("scancode", key_value)
				#else:
					#object_action.set("scancode", 0)
				##print(object_action.get("scancode"))
		#
		##game_controls.set_value(config_section, action, inital_controls)
		#game_controls.save(controls_filepath)
		#
##		var key_value = keyboard_keybinds[key]
##		if key_value != null:
##			game_controls.set_value(config_section, key, key_value)
##		else:
##			game_controls.set_value(config_section, key, "")
	##game_controls.save(controls_filepath)
#
#func save_new_gamepad_config():
	#
	#for key in gamepad_keybinds.keys():
		#var action_list = game_controls.get_value(config_section, key)
		#var joy_value_new = gamepad_keybinds[key]
		#
		#for object_action in action_list:
			#if object_action.get_class() == "InputEventJoypadMotion":
				#if joy_value_new != null:
					#if joy_value_new.has("axis"):
						#object_action.set("axis", joy_value_new["axis"])
						#object_action.set("axis_value", joy_value_new["axis_value"])
				#else:
					#object_action.set("axis", 777)
					#object_action.set("axis_value", 777)
					#print(object_action.get("axis"))
					#print(object_action.get("axis_value"))
				##print(object_action.get("scancode"))
			#elif object_action.get_class() == "InputEventJoypadButton":
				#if joy_value_new != null:
					#if joy_value_new.has("button_index"):
						#object_action.set("button_index", joy_value_new["button_index"])
				#else:
					#object_action.set("button_index", 777)
					#print(object_action.get("button_index"))
		#
		##game_controls.set_value(config_section, action, inital_controls)
		#game_controls.save(controls_filepath)
#
#func get_key(action):
	#var action_list = InputMap.get_action_list(action)
	#for key in action_list:
		#if key is InputEventKey:
			#return OS.get_scancode_string(key.get("scancode"))
