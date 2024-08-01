extends CharacterBody2D

var screen_size : Vector2
var speed = 400
var input_direction = Input.get_vector("left", "right", "up", "down")

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
		position.x += speed * delta
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.animation = "walk_left"
		position.x -= speed * delta
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.animation = "walk_down"
		position.y += speed * delta
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.animation = "walk_up"
		position.y -= speed * delta
	
	#$AnimatedSprite2D.animation = "walk_right"
	# Player animation
	if Input.is_anything_pressed():
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
