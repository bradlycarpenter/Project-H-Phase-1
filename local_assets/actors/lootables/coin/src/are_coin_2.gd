extends Area2D

@onready var ans_coin_2 = $ans_coin_2

@onready var game_manager = get_tree().root.get_node("nod_gamemanager")

func coin_picked_up():
	game_manager.increase_coin_count()
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		coin_picked_up()
		ans_coin_2.play("collect")
