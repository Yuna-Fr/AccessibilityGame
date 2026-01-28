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
