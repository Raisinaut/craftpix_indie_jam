class_name PlayerCharacter
extends MovingCharacter

var input_direction := Vector2.ZERO
var last_input_direction := Vector2.ZERO


func _ready() -> void:
	super()
	GameManager.player = self

func update_input_direction() -> void:
	input_direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down")

func _input(event: InputEvent) -> void:
	update_input_direction()
	move_direction = input_direction


# CHECKS -----------------------------------------------------------------------
func is_busy() -> bool:
	return (
		not state == STATES.MOVE
	)
