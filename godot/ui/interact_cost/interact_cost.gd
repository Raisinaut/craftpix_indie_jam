@tool

extends PanelContainer

@export var action : String = "" : set = set_action
@export_range(0, 99, 1, "or_greater") var cost : int = 0 : set = set_cost

@onready var action_label = %ActionLabel
@onready var cost_label = %CostLabel
@onready var original_position = global_position


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		keep_onscreen()

func set_action(value : String):
	action = value
	%ActionLabel.text = action

func set_cost(value : int):
	cost = value
	%CostLabel.text = str(cost)

func keep_onscreen() -> void:
	var viewport_rect = get_viewport_rect()
	var viewport_origin = viewport_rect.position
	var viewport_extent = viewport_origin + viewport_rect.size
	var max_position = viewport_extent - size
	global_position.x = clamp(original_position.x, viewport_origin.x, max_position.x)
	global_position.y = clamp(original_position.y, viewport_origin.y, max_position.y)
