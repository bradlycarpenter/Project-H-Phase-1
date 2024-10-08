extends CharacterBody2D

@export var coin_scene: PackedScene

@onready var animation : AnimationTree = $ani_t
@onready var hitboxes : Array = [$are_hitboxes_2/csh_fists_2,$are_hitboxes_2/csh_impact_2]
@onready var sprite : Sprite2D = $spr_2
@onready var attacking_area : Area2D = $are_attacking_area_2

var health: int = 30
var chase_player = false
var players_detected: Array = []
var speed : int = 200
var direction : Vector2

func flip_sprite() -> void:
	if direction.x > 0:
		sprite.flip_h = true
	if direction.x < 0:
		sprite.flip_h = false

func flip_hitboxes(dir) -> void:
	for hitbox in hitboxes:
		hitbox.position.x = sign(dir.x) * 124

func detect_player(body) -> void:
	if body.is_in_group("Player"):
		if !players_detected.has(body):
			players_detected.append(body)
			chase_player = true

func undetect_player(body) -> void:
	if body.is_in_group("Player"):
		if players_detected.has(body):
			players_detected.erase(body)
			if players_detected.size() == 0:
				chase_player = false

func movement(delta) -> void:
	if chase_player && animation["parameters/playback"].get_current_node() != "side_attack":
		direction = (players_detected[0].position - position).normalized()
		position += direction * speed * delta

func start_moving() -> void:
	animation["parameters/conditions/idle"] = false
	animation["parameters/conditions/is_moving"] = true

func stop_moving() -> void:
	animation["parameters/conditions/is_moving"] = false
	animation["parameters/conditions/idle"] = true

func _on_detection_area_entered(body: Node2D) -> void:
	detect_player(body)
	if chase_player:
		start_moving()

func _on_detection_area_exited(body: Node2D) -> void:
	undetect_player(body)
	if !chase_player:
		stop_moving()

func _melee_range_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation["parameters/conditions/is_moving"] = false
		animation["parameters/conditions/is_attacking"] = true

func _on_melee_range_exited(_body: Node2D) -> void:
	animation["parameters/conditions/is_attacking"] = false

func _player_hit(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.receive_damage(30)

func take_damage(damage) -> void:
	health -= damage
	if health <= 0:
		call_deferred("_spawn_coin", Vector2(-10, 0))
		call_deferred("_spawn_coin", Vector2(10, 0))
		call_deferred("queue_free")

func _ready() -> void:
	animation["parameters/conditions/idle"] = true

func _physics_process(delta: float) -> void:
	movement(delta)
	flip_sprite()
	flip_hitboxes(direction)

func _spawn_coin(offset: Vector2) -> void:
	var coin_instance = coin_scene.instantiate()
	coin_instance.position = global_position + offset
	get_parent().add_child(coin_instance)
