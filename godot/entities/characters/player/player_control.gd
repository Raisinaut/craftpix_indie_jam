extends Node2D

@export var control_target : PlayerCharacter = null

var input_direction := Vector2.ZERO
var last_input_direction := Vector2.ZERO


func _process(_delta: float) -> void:
	update_input_direction()
	match(control_target.state):
		control_target.STATES.MOVE:
			control_target.move_direction = input_direction

func update_input_direction() -> void:
	input_direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down")
