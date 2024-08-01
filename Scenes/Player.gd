extends CharacterBody2D

var screen_size : Vector2
var speed = 400

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _physics_process(delta):
	#limit movement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Determine the direction of the animation based on the input using if-elif
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.animation = "walk_right"
		$AnimatedSprite2D.play()
		position.x += speed * delta
		if Input.is_action_pressed("up"):
			position.y -= speed * delta * 0.5
		elif Input.is_action_pressed("down"):
			position.y += speed * delta * 0.5
			
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.animation = "walk_left"
		$AnimatedSprite2D.play()
		position.x -= speed * delta
		if Input.is_action_pressed("up"):
			position.y -= speed * delta * 0.5
		elif Input.is_action_pressed("down"):
			position.y += speed * delta * 0.5
			
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.animation = "walk_down"
		$AnimatedSprite2D.play()
		position.y += speed * delta
		
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.animation = "walk_up"
		$AnimatedSprite2D.play()
		position.y -= speed * delta
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
