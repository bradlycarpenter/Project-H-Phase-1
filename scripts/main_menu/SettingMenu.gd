class_name SettingMenu
extends Control

@onready var exit_button := $MarginContainer/VBoxContainer/Exit_Button

signal exit_options_menu 
	

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)#disables button after clicked until proscess true
	
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
