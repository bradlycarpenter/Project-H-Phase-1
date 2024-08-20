
extends CharacterBody2D

var direction : Vector2
var sword_sfx_playing : bool = false

@export var speed : int = 30

@onready var ant_player_char1 : AnimationTree = $ant_player_char1
@onready var nod_player_char1_2 : Node2D = $nod_player_char1_2
@onready var are_player_char1_2 : Area2D   = $are_attacks_2
@onready var asp_fts: AudioStreamPlayer = $asp_fts
@onready var asp_swr: AudioStreamPlayer = $asp_swr
@onready var tim_fts: Timer = $tim_fts
# Audio
# ______________________________________________________________________________
func play_footsteps():
	if direction and tim_fts.is_stopped():
		asp_fts.pitch_scale = randf_range(0.8, 1.2)
		asp_fts.play()
		tim_fts.start(1.4 * (speed * 0.01))

func play_slash():
	if Input.is_action_just_pressed("p1_attack1") && !sword_sfx_playing:
		asp_swr.pitch_scale = randf_range(0.8, 1.2)
		asp_swr.play()
		sword_sfx_playing = true
# Animation
# ______________________________________________________________________________
func flip_sprite(dir: Vector2) -> void:
	if is_attacking():
		nod_player_char1_2.scale.x = sign(dir.x)
		are_player_char1_2.position.x = sign(dir.x) * 48

func update_animation_parameters() -> void:
	if velocity == Vector2.ZERO:
		ant_player_char1["parameters/conditions/idle"] = true
		ant_player_char1["parameters/conditions/is_moving"] = false
	else:
		ant_player_char1["parameters/conditions/idle"] = false
		ant_player_char1["parameters/conditions/is_moving"] = true
	if Input.is_action_just_pressed("p1_attack1"):
		ant_player_char1["parameters/conditions/swing"] = true
	else:
		ant_player_char1["parameters/conditions/swing"] = false
# Value Checking
# ______________________________________________________________________________
func is_attacking():
	var attacking : bool = false
	if ant_player_char1["parameters/playback"].get_current_node() == "attack":
		return attacking
	else:
		return !attacking 

func check_direction() -> Vector2:
	return Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")

func check_velocity(delta, dir: Vector2) -> Vector2:
	if dir:
		velocity = dir * speed * (delta*1000)
	else:
		velocity = Vector2.ZERO
	return velocity

func _on_ant_player_char1_animation_finished(_attack: StringName) -> void:
	sword_sfx_playing = false
# Gameplay
# ______________________________________________________________________________
func _ready():
	ant_player_char1.active = true

func _process(_delta):
	update_animation_parameters()

func _physics_process(delta):
	direction = check_direction()
	velocity = check_velocity(delta, direction)
	move_and_slide()
	if direction.x != 0:
		flip_sprite(direction)
	play_footsteps()
	play_slash()


func _on_area_attacks_2_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(30)
