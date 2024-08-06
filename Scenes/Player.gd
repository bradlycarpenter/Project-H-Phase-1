extends CharacterBody2D

var screen_size : Vector2
var speed = 400
var direction : Vector2
var last_direction : Vector2 = Vector2.ZERO  # Store the last movement direction
var attacking = false
var attack_animation = ""
var attack_duration = 0.5  # Duration of the attack animation in seconds
var attack_timer = 0.0
@onready var footstep_player = $FootstepPlayer

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	

func _physics_process(delta):
	movement(delta)
	spriteDirection()
	spriteSelect()
	attack(delta)
	playerAudio()

func playerAudio():
	if direction and !footstep_player.playing:
		footstep_player.play()

func attack(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !attacking:
		attacking = true
		attack_animation = get_attack_animation()
		attack_timer = attack_duration
		$Area2D/side_attack.disabled = false
	else:
		if attack_timer > 0:
			attack_timer -= delta
		else:
			attacking = false
			$Area2D/side_attack.disabled = true

func movement(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		last_direction = direction  # Update last direction if movement is detected
	velocity = direction * speed * delta
	position += velocity 

func spriteDirection():
	if direction.x < 0 and not $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = true
		$Area2D.scale.x = -1
	elif direction.x > 0 and $AnimatedSprite2D.flip_h:
		$AnimatedSprite2D.flip_h = false
		$Area2D.scale.x = 1

func spriteSelect():
	if attacking:
		if not $AnimatedSprite2D.is_playing() or $AnimatedSprite2D.animation != attack_animation:
			$AnimatedSprite2D.play(attack_animation)
		# Reset attack state after the animation duration
		if attack_timer <= 0:
			attacking = false
	else:
		if direction:
			$AnimatedSprite2D.play()
			if direction.x != 0:
				$AnimatedSprite2D.animation = "walk_right"
		else:
			$AnimatedSprite2D.stop()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Hit"):
		body._take_damage(10)
	else:
		pass # Replace with function body.

func get_attack_animation():
	if last_direction.y < 0:
		return "attack_up"
	elif last_direction.y > 0:
		return "attack_down"
	elif last_direction.x != 0:
		return "attack_side"
	# Default to a side attack if no last direction is available
	return "attack_side"
