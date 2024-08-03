extends CharacterBody2D

var screen_size : Vector2
var speed = 400
var direction : Vector2


func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$Area2D/hitbox.disabled = false
	else:
		$Area2D/hitbox.disabled = true

func _movement(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * delta
	position += velocity 

func _spriteDirection():
	if direction.x < 0 and not $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = true
		$Area2D.scale.x = -1
	elif direction.x > 0 and $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = false
		$Area2D.scale.x = 1

func _spriteSelect():
	if direction:
		$AnimatedSprite2D.play()
		if direction.y < 0:
			$AnimatedSprite2D.animation = "walk_up"
		elif direction.y > 0:
			$AnimatedSprite2D.animation = "walk_down"
		elif direction.x != 0:
			$AnimatedSprite2D.animation = "walk_right"
	else:
		$AnimatedSprite2D.stop()
		
func _physics_process(delta):
	#limit movement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	_movement(delta)
	_spriteDirection()
	_spriteSelect()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Hit"):
		body._take_damage()
	else:
		pass # Replace with function body.
