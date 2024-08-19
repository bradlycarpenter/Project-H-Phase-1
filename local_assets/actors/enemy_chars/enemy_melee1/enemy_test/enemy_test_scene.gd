extends Node

@onready var lab_coin_count = $"../cnv_coin_counter_l/lab_coin_count"

var coin_count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	update_coin_count_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func increase_coin_count():
	coin_count += 1
	update_coin_count_label()

func update_coin_count_label():
	lab_coin_count.text = "Coins: %d" % coin_count
