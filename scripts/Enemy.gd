extends CharacterBody2D

var speed = 85
var player_chase = false
var players : Array = []  # Array to store player references
var direction : Vector2
var last_flip_h = false
var health = 30

@export var damage_shader: Shader
var original_material: ShaderMaterial
var shader_applied: bool = false
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	# Save the original material if needed
	if animated_sprite_2d.material and animated_sprite_2d.material is ShaderMaterial:
		original_material = animated_sprite_2d.material

func _physics_process(delta):
	$Label.text = str(health)
	if player_chase:
		_movement(delta)
		_update_animation()
	else:
		$AnimatedSprite2D.stop()

func _movement(delta):
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
		var direction = (nearest_player.position - position).normalized()
		position += direction * speed * delta

func _update_animation():
	if players.size() > 0:
		var nearest_player = players[0]
		var nearest_distance = position.distance_to(nearest_player.position)

		for player in players:
			var distance = position.distance_to(player.position)
			if distance < nearest_distance:
				nearest_player = player
				nearest_distance = distance

		var new_flip_h = nearest_player.position.x < position.x
		if abs(nearest_player.position.x - position.x) > abs(nearest_player.position.y - position.y):
			# Horizontal movement
			if new_flip_h != last_flip_h:
				animated_sprite_2d.flip_h = new_flip_h
				last_flip_h = new_flip_h
			animated_sprite_2d.play("slime")
		else:
			# Vertical movement
			if nearest_player.position.y < position.y:
				animated_sprite_2d.play("slime")
			else:
				animated_sprite_2d.play("slime")

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

func take_damage(damage):
	if damage_shader:
		if not shader_applied:
			# Apply the damage shader for one frame
			var shader_material = ShaderMaterial.new()
			shader_material.shader = damage_shader
			animated_sprite_2d.material = shader_material
			shader_applied = true
			
			# Schedule to revert the material in the next frame
			await get_tree().create_timer(0.075).timeout
			animated_sprite_2d.material = original_material
			shader_applied = false
	health -= damage
	if health <= 0:
		queue_free()
