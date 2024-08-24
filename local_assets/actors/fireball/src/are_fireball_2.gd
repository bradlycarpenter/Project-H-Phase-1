extends Area2D

var speed: float = 500.0  # Speed of the fireball
var direction: Vector2 = Vector2.ZERO  # Direction of the fireball's movement

func _ready():
	# Rotate the fireball towards the direction it's moving
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	# Move the fireball in the specified direction
	position += direction * speed * delta
	# Handle out-of-bounds conditions if needed
	if position.x < 0 or position.x > get_viewport().size.x or position.y < 0 or position.y > get_viewport().size.y:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.receive_damage(10)
		queue_free()
