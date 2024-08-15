extends Node2D

var enemy_scene := preload("res://local_assets/actors/enemy_chars/enemy_melee1/src/cbd_enemy_melee1_2.tscn")
var spawn_points : Array = []

@onready var mrk_spawn1_2 = $mrk_spawn1_2
@onready var mark_spawn2_2 = $mark_spawn2_2

@onready var test = preload("res://local_assets/actors/enemy_chars/enemy_melee1/enemy_test/nod_enemy_test.tscn")

func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
	#var spawn = spawn_points[randi() % spawn_points.size()]
	
# Instantiate and place enemies at spawn points
	for spawn in spawn_points:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn.position
		add_child(enemy)  # Add the enemy to the current node (Node2D)
	#var enemy = enemy_scene.instantiate()
	#enemy.position = spawn.position
	#main.call_deferred("add_child", enemy)
