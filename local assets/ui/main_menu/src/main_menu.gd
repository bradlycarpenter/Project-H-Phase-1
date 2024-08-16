class_name MainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/start_button
@onready var multi_player_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/multi_player_button
@onready var option_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/option_button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/exit_button
@onready var margin_container := $MarginContainer
@onready var pup_option_menu: SettingMenu = $pup_option_menu


const LEVEL_1 = preload("res://local assets/levels/level1/src/level1.tscn")


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_1)
	
func on_exit_pressed() -> void:
	get_tree().quit()

func on_option_pressed() -> void:
	margin_container.visible = false
	pup_option_menu.set_process(true)
	pup_option_menu.visible = true

func on_exit_option_menu() -> void:
	margin_container.visible = true
	pup_option_menu.visible = false

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	pup_option_menu.exit_options_menu.connect(on_exit_option_menu)

func _ready():
	handle_connecting_signals()
