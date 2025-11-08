extends NavigationAgent2D

@export var control_target : MovingCharacter

var final_position := Vector2.ZERO
var move_direction := Vector2.ZERO


func navigate_to_position(p : Vector2) -> void:
	target_position = p
	final_position = get_final_position()

func stop_navigation() -> void:
	target_position = control_target.global_position

func _process(_delta: float) -> void:
	move_direction = Vector2.ZERO
	if not is_navigation_finished():
		var waypoint_position = get_next_path_position()
		var start_position = control_target.global_position
		move_direction = start_position.direction_to(waypoint_position)
	control_target.move_direction = move_direction
