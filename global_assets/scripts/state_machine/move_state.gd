extends State

class_name MoveState

func _ready() -> void:
    animation_tree["parameters/conditions/is_moving"] = true

func _physics_process(_delta: float) -> void:
    if velocity == 0:
        animation_tree["parameters/conditions/is_moving"] = false
        animation_tree["parameters/conditions/idle"] = true
