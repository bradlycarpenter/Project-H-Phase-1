extends CharacterBody2D

var speed = 85
var player_chase =  false
var Player = null
var direction : Vector2 = Vector2.ZERO
	
	
func _physics_process(delta):
	
	if player_chase:
		position += (Player.position - position)/speed
		
		$AnimatedSprite2D.play("walk_left")
		
		if(Player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true #left
		else:
			$AnimatedSprite2D.flip_h = false #right
	else:
		$AnimatedSprite2D.play("idle")
	

func _on_detection_area_body_entered(body):
	Player = body
	player_chase = true
	
func _on_detection_area_body_exited(body):
	Player = null
	player_chase = false

