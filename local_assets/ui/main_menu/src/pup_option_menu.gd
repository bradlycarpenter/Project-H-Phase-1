class_name SettingMenu
extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/exit_button
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../MusicStreamPlayer/AudioStreamPlayer2D"

signal exit_options_menu 
	

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)#disables button after clicked until proscess true
	
func on_exit_pressed() -> void:
	audio_stream_player_2d.play()
	exit_options_menu.emit()
	set_process(false)
