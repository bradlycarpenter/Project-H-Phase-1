extends CharacterBody2D

var speed = 85
var player_chase =  false
var Player = null
var direction : Vector2

func _physics_process(_delta):
	if player_chase:
		# Move towards the player
		position += (Player.position - position) / speed
		
		# Determine which animation to play
		if abs(Player.position.x - position.x) > abs(Player.position.y - position.y):
			# Horizontal movement
			if Player.position.x < position.x:
				$AnimatedSprite2D.play("walk_right")
				$AnimatedSprite2D.flip_h = true  # Facing left
			else:
				$AnimatedSprite2D.play("walk_right")
				$AnimatedSprite2D.flip_h = false  # Facing right
		else:
			# Vertical movement
			if Player.position.y < position.y:
				$AnimatedSprite2D.play("walk_up")
			else:
				$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.stop()

func _on_detection_area_body_entered(body):
	Player = body
	player_chase = true

func _on_detection_area_body_exited(_body):
	Player = null
	player_chase = false
