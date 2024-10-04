extends Node

const IDLE_TIMEOUT = 60.0
const POPUP_DISPLAY_TIME = 3.0

var idle_timer: Timer
var popup_timer: Timer
var return_popup: PopupPanel

func _ready() -> void:
	idle_timer = $IdleTimer
	popup_timer = $PopupTimer
	return_popup = $ReturnToMenuPopup
	
	idle_timer.wait_time = IDLE_TIMEOUT
	idle_timer.one_shot = true
	idle_timer.start()
	
	popup_timer.one_shot = true
	popup_timer.wait_time = POPUP_DISPLAY_TIME
	
	idle_timer.timeout.connect(_on_IdleTimer_timeout)
	popup_timer.timeout.connect(_on_PopupTimer_timeout)
	
	
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		idle_timer.start()
		
func _on_IdleTimer_timeout():
	print("Returning to main menu due to inactivity.")
	return_popup.show()
	popup_timer.start()


func _on_PopupTimer_timeout() -> void:
	get_tree().change_scene_to_file("res://local_assets/ui/main_menu/src/main_menu.tscn")
