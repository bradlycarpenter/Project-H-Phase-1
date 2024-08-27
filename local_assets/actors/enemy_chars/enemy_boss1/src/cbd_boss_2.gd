extends CharacterBody2D
class_name BossEnemy

func _physics_process(_delta) -> void:
	move_and_slide()

	if velocity.length() > 0:
		$ani_t["parameters/conditions/idle"] = false
		$ani_t["parameters/conditions/is_moving"] = true
	else:
		$ani_t["parameters/conditions/idle"] = true 
		$ani_t["parameters/conditions/is_moving"] = false

	if velocity.x > 0:
		$spr_2.flip_h = true

	elif velocity.x < 0:
		$spr_2.flip_h = false
