extends CharacterBody2D

@onready var animation : AnimationTree = $ani_t
@onready var hitboxes : Array = [$are_hitboxes_2/csh_fists_2,$are_hitboxes_2/csh_impact_2]
@onready var sprite : Sprite2D = $spr_2
@onready var attacking_area : Area2D = $are_attacking_area_2

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
	attacking_area.position.x = sign(dir.x) * 128
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
	start_moving()

func _on_detection_area_exited(body: Node2D) -> void:
	undetect_player(body)
	stop_moving()

func _melee_range_entered(_body: Node2D) -> void:
	animation["parameters/conditions/is_attacking"] = true

func _on_melee_range_exited(_body: Node2D) -> void:
	animation["parameters/conditions/is_attacking"] = false

func _ready() -> void:
	animation.active = true
	animation["parameters/conditions/idle"] = true

func _physics_process(delta: float) -> void:
	movement(delta)
	flip_sprite()
	flip_hitboxes(direction)
