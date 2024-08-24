extends Control

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://local_assets/ui/main_menu/src/main_menu.tscn")
