extends CharacterBody2D

var screen_size : Vector2
var speed = 10
var direction : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _movement():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	position += velocity
	if direction:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func _spriteDirection():
	if (!$AnimatedSprite2D.flip_h and direction.x < 0):
		$AnimatedSprite2D.flip_h = true
	elif ($AnimatedSprite2D.flip_h and direction.x > 0):
		$AnimatedSprite2D.flip_h = false

func _spriteSelect():
	if direction.y < 0:
		$AnimatedSprite2D.animation = "walk_up"
	elif direction.y > 0:
		$AnimatedSprite2D.animation = "walk_down"
	elif direction.x != 0:  # When moving horizontally
		$AnimatedSprite2D.animation = "walk_right"

func _physics_process(_delta):
	#limit movement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	_movement()
	_spriteDirection()
	_spriteSelect()
