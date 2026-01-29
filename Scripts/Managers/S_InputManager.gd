extends MarginContainer

const CONFIG_PATH := "user://keybindings.cfg"
const REBINDABLE_ACTIONS := [
	"Move_Up",
	"Move_Down",
	"Move_Left",
	"Move_Right",
	"Action"
]
const CONTROLLER_LABELS: Dictionary = {
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

	elif bind_type == BindType.GAMEPAD and event is InputEventJoypadButton and event.pressed:
		rebind_gamepad(action_to_rebind, event)
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
	for ev in InputMap.action_get_events(action):
		if type == BindType.KEYBOARD and ev is InputEventKey:
			return ev.as_text()
		if type == BindType.GAMEPAD and ev is InputEventJoypadButton:
			return CONTROLLER_LABELS.get(ev.button_index, "Btn " + str(ev.button_index))
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
	
	cfg.save(CONFIG_PATH)

func load_bindings():
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK: return
	
	for action in REBINDABLE_ACTIONS:
		# Remove existing events
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey or InputEventJoypadButton:
				InputMap.action_erase_event(action, ev)
		
		# Load keyboard
		if cfg.has_section_key("keys", action):
			var key := InputEventKey.new()
			key.keycode = cfg.get_value("keys", action)
			InputMap.action_add_event(action, key)

		# Load gamepad
		if cfg.has_section_key("pads", action):
			var pad := InputEventJoypadButton.new()
			pad.button_index = cfg.get_value("pads", action)
			InputMap.action_add_event(action, pad)

#endregion

func getButton(action: String) -> Button :
	if action == "Move_Up" : return move_up_btn
	if action == "Move_Down" : return move_down_btn
	if action == "Move_Left" : return move_left_btn
	if action == "Move_Right" : return move_right_btn
	if action == "Action" : return action_btn
	return null
