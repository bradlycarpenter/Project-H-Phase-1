extends CharacterBody2D

var speed = 85
var player_chase =  false
var player = null
var direction : Vector2
var last_flip_h = false
var health = 30

@export var damage_shader: Shader
var original_material: ShaderMaterial
var shader_applied: bool = false

func _ready():
	# Save the original material if needed
	if $AnimatedSprite2D.material and $AnimatedSprite2D.material is ShaderMaterial:
		original_material = $AnimatedSprite2D.material


func _physics_process(delta):
	$Label.text = str(health)
	if player_chase:
		_movement(delta)
		_update_animation()
	else:
		$AnimatedSprite2D.stop()

func _movement(delta):
	if player:
		position += (player.position - position).normalized()
		velocity = direction * speed * delta
		position += velocity 

func _update_animation():
	if player:
		var new_flip_h = player.position.x < position.x
		if abs(player.position.x - position.x) > abs(player.position.y - position.y):
			# Horizontal movement
			if new_flip_h != last_flip_h:
				$AnimatedSprite2D.flip_h = new_flip_h
				last_flip_h = new_flip_h
			$AnimatedSprite2D.play("walk_right")
		else:
			# Vertical movement
			if player.position.y < position.y:
				$AnimatedSprite2D.play("walk_up")
			else:
				$AnimatedSprite2D.play("walk_down")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false

func take_damage(damage):
	if damage_shader:
		if not shader_applied:
			# Apply the damage shader for one frame
			var shader_material = ShaderMaterial.new()
			shader_material.shader = damage_shader
			$AnimatedSprite2D.material = shader_material
			shader_applied = true
			
			# Schedule to revert the material in the next frame
			await get_tree().create_timer(0.075).timeout
			$AnimatedSprite2D.material = original_material
			shader_applied = false
	health -= damage
	if health <= 0:
		queue_free()
