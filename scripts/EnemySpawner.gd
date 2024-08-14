extends Node2D

var enemy_scene := preload("res://scenes/enemy.tscn")
var spawn_points : Array = []

@onready var main = get_node("/root/Main")

func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
	var spawn = spawn_points[randi() % spawn_points.size()]
	
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn.position
	main.call_deferred("add_child", enemy)
