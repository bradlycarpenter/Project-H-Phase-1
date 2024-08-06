extends CharacterBody2D

var speed = 85
var player_chase =  false
var player = null
var direction : Vector2
var last_flip_h = false
var health = 30

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

func _take_damage(damage):
	health -= damage  # Replace with your health variable
	if health <= 0:  # Check if health is depleted
		queue_free()
