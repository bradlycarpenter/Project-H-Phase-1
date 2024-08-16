class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button
@export var action_name : String = "up1"

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"p1_up":
			label.text = "Move up"
		"p1_down": #Move Up
			label.text = "Move down"
		"p1_left": #Move Down
			label.text = "Move Left"
		"p1_right": #Move Right
			label.text = "Move Right"
		#"attack": Mouse Attack TODO: InputEventMouseButton
			#label.text = "Attack"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	button.text = "%s" % action_keycode

func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "press any keyy..."
		set_process_unhandled_key_input(button_pressed)
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
