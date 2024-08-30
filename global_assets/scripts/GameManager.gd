class_name Game_Manager
extends Node

@onready var lab_coin_count = $"../cnv_coin_counter_l/lab_coin_count"
@onready var asp_coin = $asp_coin

var coin_count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	update_coin_count_label()

func increase_coin_count():
	coin_count += 1
	update_coin_count_label()
	asp_coin.play()

func update_coin_count_label():
	lab_coin_count.text = "Coins: %d" % coin_count

func update_player_health(_health):
	pass
	# var _hp = str(health)
