extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer/AudioStreamPlayer2D


func _on_exit_button_pressed() -> void:
	audio_stream_player_2d.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://local_assets/ui/main_menu/src/main_menu.tscn")
