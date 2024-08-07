extends CharacterBody2D

var screen_size : Vector2
var speed := 500
var direction : Vector2
var last_direction : Vector2 = Vector2.ZERO
var attacking := false
var attack_animation := ""
var attack_duration := 0.5
var attack_timer := 0.5
var sword_sfx_played := false

@onready var footstep_player = $FootstepPlayer
@onready var timer = $Timer
@onready var sword_sfx = $SwordSFXPlayer
@onready var side_attack = $Area2D/side_attack
@onready var up_attack = $Area2D/up_attack
@onready var down_attack = $Area2D/down_attack
@onready var sprite = $AnimatedSprite2D

# Use this variable to differentiate between Player 1 and Player 2
@export var player_id : int = 1

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	if is_in_group("Player"):
		print("Player 1: This node is in the Player group")

func _physics_process(delta):
	movement(delta)
	spriteDirection()
	spriteSelect()
	attack(delta)
	playerAudio()

func playerAudio():
	if direction and timer.is_stopped():
		footstep_player.pitch_scale = randf_range(0.8, 1.2)
		footstep_player.play()
		timer.start(0.3 * (speed * 0.01))
	if attacking and not sword_sfx_played:
		if not sword_sfx_played:
			sword_sfx.pitch_scale = randf_range(0.8, 1.2)
			sword_sfx.play()
			sword_sfx_played = true

func attack(delta):
	if Input.is_action_just_pressed("attack_" + str(player_id)) and not attacking:
		attacking = true
		sword_sfx_played = false
		attack_animation = get_attack_animation()
		attack_timer = attack_duration
	else:
		if attack_timer > 0:
			attack_timer -= delta
		else:
			attacking = false
			sword_sfx_played = false
			side_attack.disabled = true
			up_attack.disabled = true
			down_attack.disabled = true

func movement(delta):
	direction = Input.get_vector("left_" + str(player_id), "right_" + str(player_id), "up_" + str(player_id), "down_" + str(player_id))
	if direction != Vector2.ZERO:
		last_direction = direction  # Update last direction if movement is detected
	velocity = direction * speed * delta
	position += velocity 

func spriteDirection():
	if direction.x < 0 and not sprite.flip_h:
		side_attack.disabled = true
		sprite.flip_h = true
		$Area2D.scale.x = -1
	elif direction.x > 0 and sprite.flip_h:
		side_attack.disabled = true
		sprite.flip_h = false
		$Area2D.scale.x = 1

func spriteSelect():
	if attacking:
		if not sprite.is_playing() or sprite.animation != attack_animation:
			sprite.play(attack_animation)
		# Reset attack state after the animation duration
		if attack_timer <= 0:
			attacking = false
	else:
		if direction:
			sprite.play()
			if direction.x != 0:
				sprite.animation = "walk_right"
		else:
			sprite.animation = "walk_down"
			sprite.stop()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Hit"):
		body.take_damage(10)
	else:
		pass # Replace with function body.

func get_attack_animation():
	if last_direction.y < 0:
		up_attack.disabled = false
		return "attack_up"
	elif last_direction.y > 0:
		down_attack.disabled = false
		return "attack_down"
	elif last_direction.x != 0:
		side_attack.disabled = false
		return "attack_side"
	# Default to a side attack if no last direction is available
	return "attack_side"
