extends State

class_name IdleState

func _ready() -> void:
    animation_tree["parameters/conditions/idle"] = true