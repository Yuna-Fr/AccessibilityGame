extends Control

const CONFIG_PATH := "user://keybindings.cfg"
const AXIS_DEADZONE := 0.5
const REBINDABLE_ACTIONS := [
	"Move_Up",
	"Move_Down",
	"Move_Left",
	"Move_Right",
	"Action"
]
const CONTROLLER_BUTTON_LABELS: Dictionary = {
	JoyButton.JOY_BUTTON_A: "A",
	JoyButton.JOY_BUTTON_B: "B",
	JoyButton.JOY_BUTTON_X: "X",
	JoyButton.JOY_BUTTON_Y: "Y",
	JoyButton.JOY_BUTTON_LEFT_SHOULDER: "LB",
	JoyButton.JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JoyButton.JOY_BUTTON_LEFT_STICK: "L3",
	JoyButton.JOY_BUTTON_RIGHT_STICK: "R3",
	JoyButton.JOY_BUTTON_DPAD_UP: "Up",
	JoyButton.JOY_BUTTON_DPAD_DOWN: "Down",
	JoyButton.JOY_BUTTON_DPAD_LEFT: "Left",
	JoyButton.JOY_BUTTON_DPAD_RIGHT: "Right",
	JoyButton.JOY_BUTTON_START: "Start",
	JoyButton.JOY_BUTTON_GUIDE: "Select",
}
const CONTROLLER_AXIS_LABEL: Dictionary = {
	JoyAxis.JOY_AXIS_LEFT_X: "L-Stick X",
	JoyAxis.JOY_AXIS_LEFT_Y: "L-Stick Y",
	JoyAxis.JOY_AXIS_RIGHT_X: "R-Stick X",
	JoyAxis.JOY_AXIS_RIGHT_Y: "R-Stick Y",
}

@export var move_up_btn : Button
@export var move_down_btn : Button
@export var move_left_btn : Button
@export var move_right_btn : Button
@export var action_btn : Button

@export var move_up_gamepad : Button
@export var move_down_gamepad : Button
@export var move_left_gamepad : Button
@export var move_right_gamepad : Button
@export var action_gamepad : Button

@export var reset_btn : Button
@export var finish_btn : Button

enum BindType { KEYBOARD, GAMEPAD }
var bind_type : BindType

var waiting_for_input := false
var action_to_rebind := ""

func _ready():
	load_bindings()
	update_button_labels()
	
	move_up_btn.pressed.connect(func(): start_rebind("Move_Up", BindType.KEYBOARD))
	move_down_btn.pressed.connect(func(): start_rebind("Move_Down", BindType.KEYBOARD))
	move_left_btn.pressed.connect(func(): start_rebind("Move_Left", BindType.KEYBOARD))
	move_right_btn.pressed.connect(func(): start_rebind("Move_Right", BindType.KEYBOARD))
	action_btn.pressed.connect(func(): start_rebind("Action", BindType.KEYBOARD))
	
	move_up_gamepad.pressed.connect(func(): start_rebind("Move_Up", BindType.GAMEPAD))
	move_down_gamepad.pressed.connect(func(): start_rebind("Move_Down", BindType.GAMEPAD))
	move_left_gamepad.pressed.connect(func(): start_rebind("Move_Left", BindType.GAMEPAD))
	move_right_gamepad.pressed.connect(func(): start_rebind("Move_Right", BindType.GAMEPAD))
	action_gamepad.pressed.connect(func(): start_rebind("Action", BindType.GAMEPAD))

	reset_btn.pressed.connect(func(): reset_bindings())
	finish_btn.pressed.connect(func(): finish())

func finish(): #to delete tomorrow
	self.visible = false

#region Input Capture and Rebinding
func reset_bindings():
	InputMap.load_from_project_settings()

	# Remove saved bindings file
	if FileAccess.file_exists(CONFIG_PATH):
		DirAccess.remove_absolute(CONFIG_PATH)

	waiting_for_input = false
	action_to_rebind = ""

	update_button_labels()

func start_rebind(action: String, type :BindType):
	waiting_for_input = true
	action_to_rebind = action
	bind_type = type

func _input(event):
	if not waiting_for_input: return

	if bind_type == BindType.KEYBOARD and event is InputEventKey and event.pressed:
		rebind_key(action_to_rebind, event)
		_finish_rebind()

	elif bind_type == BindType.GAMEPAD:
		if event is InputEventJoypadButton and event.pressed:
			rebind_gamepad(action_to_rebind, event)
			_finish_rebind()
		elif event is InputEventJoypadMotion and abs(event.axis_value) > AXIS_DEADZONE:
				rebind_axis(action_to_rebind, event)
				_finish_rebind()

func _finish_rebind():
	waiting_for_input = false
	action_to_rebind = ""
	update_button_labels()
	save_bindings()
	
func rebind_key(action: String, event: InputEventKey):
	# Remove duplicate gamepad
	for act in REBINDABLE_ACTIONS:
		if act == action: continue
		for ev in InputMap.action_get_events(act):
			if ev is InputEventKey and ev.keycode == event.keycode:
				InputMap.action_erase_event(act, ev)
	
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			InputMap.action_erase_event(action, ev)

	var new_event := InputEventKey.new()
	new_event.keycode = event.keycode
	InputMap.action_add_event(action, new_event)

func rebind_gamepad(action: String, event: InputEventJoypadButton):
	# Remove duplicate gamepad
	for act in REBINDABLE_ACTIONS:
		if act == action:
			continue
		for ev in InputMap.action_get_events(act):
			if ev is InputEventJoypadButton and ev.button_index == event.button_index:
				InputMap.action_erase_event(act, ev)

	for ev in InputMap.action_get_events(action):
		if ev is InputEventJoypadButton:
			InputMap.action_erase_event(action, ev)

	var new_event := InputEventJoypadButton.new()
	new_event.button_index = event.button_index
	new_event.device = event.device
	InputMap.action_add_event(action, new_event)

func rebind_axis(action: String, event: InputEventJoypadMotion):
	# Remove duplicate axis bindings
	for ev in InputMap.action_get_events(action):
		if ev is InputEventJoypadMotion:
			InputMap.action_erase_event(action, ev)

	var new_event := InputEventJoypadMotion.new()
	new_event.axis = event.axis
	new_event.axis_value = sign(event.axis_value) # +1 or -1
	new_event.device = event.device

	InputMap.action_add_event(action, new_event)

func update_button_labels():
	move_up_btn.text = get_action_label("Move_Up", BindType.KEYBOARD)
	move_down_btn.text = get_action_label("Move_Down", BindType.KEYBOARD)
	move_left_btn.text = get_action_label("Move_Left", BindType.KEYBOARD)
	move_right_btn.text = get_action_label("Move_Right", BindType.KEYBOARD)
	action_btn.text = get_action_label("Action", BindType.KEYBOARD)
	
	move_up_gamepad.text = get_action_label("Move_Up", BindType.GAMEPAD)
	move_down_gamepad.text = get_action_label("Move_Down", BindType.GAMEPAD)
	move_left_gamepad.text = get_action_label("Move_Left", BindType.GAMEPAD)
	move_right_gamepad.text = get_action_label("Move_Right", BindType.GAMEPAD)
	action_gamepad.text = get_action_label("Action", BindType.GAMEPAD)

func get_action_label(action: String, type: BindType) -> String:
	var button_event : InputEventJoypadButton = null
	var axis_event : InputEventJoypadMotion = null

	for ev in InputMap.action_get_events(action):
		if type == BindType.KEYBOARD and ev is InputEventKey:
			return ev.as_text()

		if type == BindType.GAMEPAD:
			if ev is InputEventJoypadMotion:
				axis_event = ev
			elif ev is InputEventJoypadButton:
				button_event = ev

	if axis_event:
		var axis_name: String = CONTROLLER_AXIS_LABEL.get(
			axis_event.axis, "Axis " + str(axis_event.axis))
		var dir := "+" if axis_event.axis_value > 0.0 else "-"
		return axis_name + dir
		

	if button_event:
		return CONTROLLER_BUTTON_LABELS.get(
			button_event.button_index, "Btn " + str(button_event.button_index))

	return "Unassigned"

#endregion

#region Saving
func save_bindings():
	var cfg := ConfigFile.new()
	
	for action in REBINDABLE_ACTIONS:
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey:
				cfg.set_value("keys", action, ev.keycode)
			elif ev is InputEventJoypadButton:
				cfg.set_value("pads", action, ev.button_index)
			elif ev is InputEventJoypadMotion:
				cfg.set_value("axes", action, {"axis": ev.axis, "sign": sign(ev.axis_value)})
	
	cfg.save(CONFIG_PATH)

func load_bindings():
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK: return
	
	for action in REBINDABLE_ACTIONS:
		# Remove existing events
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey or ev is InputEventJoypadButton or ev is InputEventJoypadMotion:
				InputMap.action_erase_event(action, ev)
		
		# Load keyboard
		if cfg.has_section_key("keys", action):
			var key := InputEventKey.new()
			key.keycode = cfg.get_value("keys", action)
			InputMap.action_add_event(action, key)

		# Load gamepad buttons
		if cfg.has_section_key("pads", action):
			var pad := InputEventJoypadButton.new()
			pad.button_index = cfg.get_value("pads", action)
			InputMap.action_add_event(action, pad)
		
		# Load gamepad joystick
		if cfg.has_section_key("axes", action):
			var data = cfg.get_value("axes", action)
			var axis_event := InputEventJoypadMotion.new()
			axis_event.axis = data.axis
			axis_event.axis_value = data.sign
			InputMap.action_add_event(action, axis_event)

#endregion

func getButton(action: String) -> Button :
	match action:
		"Move_Up" : return move_up_btn
		"Move_Up" : return move_up_btn
		"Move_Down" : return move_down_btn
		"Move_Left" : return move_left_btn
		"Move_Right" : return move_right_btn
		"Action" : return action_btn
		_ : return null
