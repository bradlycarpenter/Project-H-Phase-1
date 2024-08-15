extends CharacterBody2D

var is_attacking : bool = false
var is_moving : bool = false
var direction : Vector2
var sprite_flipped : bool = false

@export var speed : int = 30

@onready var ant_player_char1 : AnimationTree = $ant_player_char1
@onready var nod_player_char1_2 = $nod_player_char1_2
@onready var are_player_char1_2 = $are_player_char1_2

func flip_sprite(dir: Vector2) -> void:
	if ant_player_char1["parameters/playback"].get_current_node() != "attack":
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

func check_direction() -> Vector2:
	return Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")

func check_velocity(delta, dir: Vector2) -> Vector2:
	if dir:
		velocity = dir * speed * (delta*1000)
	else:
		velocity = Vector2.ZERO
	return velocity

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
