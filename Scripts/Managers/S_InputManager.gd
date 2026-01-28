extends Control

const CONFIG_PATH := "user://keybindings.cfg"

@export var move_up_btn : Button
@export var move_down_btn : Button 
@export var move_left_btn : Button 
@export var move_right_btn : Button 
@export var action_btn : Button 

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

#region Input Capture and Rebinding
func _input(event):
	if not waiting_for_input: return

	if event is InputEventKey and event.pressed:
		rebind_action(action_to_rebind, event)
		waiting_for_input = false
		action_to_rebind = ""
		update_button_labels()
		save_bindings()

func start_rebind(action: String):
	waiting_for_input = true
	action_to_rebind = action

func rebind_action(action: String, event: InputEventKey):
	InputMap.action_erase_events(action)
	
	var ev := InputEventKey.new()
	ev.keycode = event.keycode
	ev.pressed = true

	InputMap.action_add_event(action, ev)
func update_button_labels():
	move_up_btn.text = "Move Up:  " + get_action_key("Move_Up")
	move_down_btn.text = "Move Down:  " + get_action_key("Move_Down")
	move_left_btn.text  = "Move Left:  " + get_action_key("Move_Left")
	move_right_btn.text = "Move Right: " + get_action_key("Move_Right")
	action_btn.text = "Shoot / Jump: " + get_action_key("Action")

func get_action_key(action: String) -> String:
	var events = InputMap.action_get_events(action)

	for ev in events:
		if ev is InputEventKey:
			return ev.as_text()
	return "Unassigned"

#endregion

#region Saving
func save_bindings():
	var cfg := ConfigFile.new()
	
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		for ev in events:
			if ev is InputEventKey:
				cfg.set_value("keys", action, ev.keycode)
				break
	
	cfg.save(CONFIG_PATH)

func load_bindings():
	var cfg := ConfigFile.new()
	if cfg.load(CONFIG_PATH) != OK:
		return

	for action in cfg.get_section_keys("keys"):
		var ev := InputEventKey.new()
		ev.keycode = cfg.get_value("keys", action)
		ev.pressed = true

		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, ev)

#endregion
