extends Node2D

@export var control_target : MovingCharacter

@onready var nav_agent = $NavigationAgent2D

var final_position := Vector2.ZERO
var move_direction := Vector2.ZERO


#func _ready() -> void:
	#nav_agent.waypoint_reached.connect(_on_nav_agent_waypoint_reached)

func _input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		nav_agent.target_position = get_global_mouse_position()
		final_position = nav_agent.get_final_position()

func _process(_delta: float) -> void:
	move_direction = Vector2.ZERO
	if not nav_agent.is_navigation_finished():
		var waypoint_position = nav_agent.get_next_path_position()
		move_direction = global_position.direction_to(waypoint_position)
	control_target.move_direction = move_direction

#func _on_nav_agent_waypoint_reached(details : Dictionary) -> void:
	#if details.position == final_position:
		#print(details.position)
		#move_direction = Vector2.ZERO
