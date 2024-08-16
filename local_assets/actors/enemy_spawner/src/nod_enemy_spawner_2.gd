extends Node2D

var enemy_melee_scene := preload("res://local_assets/actors/enemy_chars/enemy_melee1/src/cbd_enemy_melee1_2.tscn")
var enemy_ranged_scene := preload("res://local_assets/actors/enemy_chars/enemy_ranged1/src/cbd_enemy_ranged1_2.tscn")

var spawn_points : Array = []
var enemy_melee
var enemy_ranged

@onready var mrk_spawn1_2 = $mrk_spawn1_2
@onready var mrk_spawn2_2 = $mrk_spawn2_2

func _ready():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
	
# Instantiate and place enemies at spawn points
	#for spawn in spawn_points:
		#var
	#	enemy = enemy_melee_scene.instantiate()
	#	enemy.position = spawn.position
	#	add_child(enemy)

	enemy_melee = enemy_melee_scene.instantiate()
	enemy_melee.position = mrk_spawn1_2.position
	add_child(enemy_melee)
	
	enemy_ranged = enemy_ranged_scene.instantiate()
	enemy_ranged.position = mrk_spawn2_2.position
	add_child(enemy_ranged)
