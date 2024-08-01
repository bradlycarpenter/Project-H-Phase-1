extends CharacterBody2D

@export var speed = 400
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func get_input():
	# keyboard input
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	# Player Movement
	get_input()
	move_and_slide()
	
	#limit movement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Determine the direction of the animation based on the input using if-elif
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.animation = "walk_right"
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.animation = "walk_left"
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.animation = "walk_down"
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.animation = "walk_up"
	
	#$AnimatedSprite2D.animation = "walk_right"
	# Player animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
