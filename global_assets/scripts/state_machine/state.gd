extends Node

class_name State

var change_state: State
var persistent_state: State
var sprite_2d: Sprite2D
var animation_tree: AnimationTree
var velocity: int = 0
var direction: Vector2

func _physics_process(_delta: float) -> void:
    persistent_state.move_and_slide(persistent_state.velocity)

func setup(change_state, animation_tree, persistent_state):
    self.change_state = change_state
    self.animation_tree = animation_tree
    self.persistent_state = persistent_state
