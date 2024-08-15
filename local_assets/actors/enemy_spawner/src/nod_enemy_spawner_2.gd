extends Node2D

var enemy_scene := preload("res://local_assets/actors/enemy_chars/enemy_melee1/src/cbd_enemy_melee1_2.tscn")

var spawn_points : Array = []

@onready var mrk_spawn1_2 = $mrk_spawn1_2
@onready var mark_spawn2_2 = $mrk_spawn2_2

func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
	
# Instantiate and place enemies at spawn points
	for spawn in spawn_points:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn.position
		add_child(enemy)
