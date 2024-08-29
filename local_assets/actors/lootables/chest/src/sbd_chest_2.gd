extends StaticBody2D

var player_entered_area : bool = false
var chest_is_open : bool = false

@export_file("*.tscn") var victory_node 

@onready var ans_chest_2: AnimatedSprite2D = $ans_chest_2
@onready var asp_chest_open: AudioStreamPlayer = $asp_chest_open


func _on_are_2_body_entered(_body: Node2D) -> void:
	player_entered_area = true
	

func _on_are_2_body_exited(_body: Node2D) -> void:
	player_entered_area = false

func _victory_menu() -> void:
	await get_tree().create_timer(3.9).timeout
	get_tree().paused = true
	get_tree().change_scene_to_file(victory_node)

func _input(event: InputEvent) -> void:
	if player_entered_area and not chest_is_open:
		if event.is_action_pressed("p1_use"):
			ans_chest_2.play()
			asp_chest_open.play()
			chest_is_open = true
			_victory_menu()
		
