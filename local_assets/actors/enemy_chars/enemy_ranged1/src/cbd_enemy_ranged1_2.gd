extends CharacterBody2D

@export var coin_scene: PackedScene

@export var damage_shader: Shader

var speed: int = 85
var player_chase: bool = false
var players : Array = []
var direction : Vector2
var last_flip_h: bool = false
var health: int = 30
var original_material: ShaderMaterial
var shader_applied: bool = false

@onready var ans_enemy_ranged1_2: AnimatedSprite2D = $nod_enemy_ranged1_2/ans_enemy_ranged1_2

@onready var lab_health = $lab_health

func _movement(delta) -> void:
	if players.size() > 0:
		# Find the nearest player
		var nearest_player = players[0]
		var nearest_distance = position.distance_to(nearest_player.position)
		for player in players:
			var distance = position.distance_to(player.position)
			if distance < nearest_distance:
				nearest_player = player
				nearest_distance = distance
		# Move towards the nearest player
		direction = (nearest_player.position - position).normalized()
		position += direction * speed * delta

func _update_animation() -> void:
	if players.size() > 0:
		var nearest_player = players[0]
		var nearest_distance = position.distance_to(nearest_player.position)
		for player in players:
			var distance = position.distance_to(player.position)
			if distance < nearest_distance:
				nearest_player = player
				nearest_distance = distance

		var new_flip_h = nearest_player.position.x < position.x
		if new_flip_h != last_flip_h:
			ans_enemy_ranged1_2.flip_h = new_flip_h
			last_flip_h = new_flip_h

		ans_enemy_ranged1_2.play("move")

func take_damage(damage) -> void:
	if damage_shader:
		if not shader_applied:
			# Apply the damage shader for a brief period
			var shader_material = ShaderMaterial.new()
			shader_material.shader = damage_shader
			ans_enemy_ranged1_2.material = shader_material
			shader_applied = true
			# Schedule to revert the material in the next frame
			await get_tree().create_timer(0.075).timeout
			ans_enemy_ranged1_2.material = original_material  # Fix here
			shader_applied = false
	health -= damage
	if health <= 0:
		var coin_instance = coin_scene.instantiate()
		coin_instance.position = global_position
		get_parent().add_child(coin_instance)
		queue_free()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		if not players.has(body):
			players.append(body)
			player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		if players.has(body):
			players.erase(body)
			if players.size() == 0:
				player_chase = false

func _ready():
	# Save the original material if needed
	if ans_enemy_ranged1_2.material and ans_enemy_ranged1_2.material is ShaderMaterial:
		original_material = ans_enemy_ranged1_2.material

func _physics_process(delta):
	lab_health.text = str(health)
	if player_chase:
		_movement(delta)
		_update_animation()
	else:
		ans_enemy_ranged1_2.stop()


func _on_area_detection_area_2_body_entered(body):
	if body.is_in_group("Player"):
		if not players.has(body):
			players.append(body)
			player_chase = true

func _on_area_detection_area_2_body_exited(body):
	if body.is_in_group("Player"):
		if players.has(body):
			players.erase(body)
			if players.size() == 0:
				player_chase = false
