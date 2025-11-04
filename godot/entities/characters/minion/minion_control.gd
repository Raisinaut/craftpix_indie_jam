extends Node2D

@export var control_target : MovingCharacter
@export var damage : int = 1

@onready var navigation = $Navigation
@onready var attack_radius = $AttackRadius


func _ready() -> void:
	control_target.attacked.connect(_on_control_target_attacked)

func _process(_delta: float) -> void:
	var enemy = get_nearest(get_tree().get_nodes_in_group("enemy"))
	if enemy:
		if has_attack_target():
			navigation.stop_navigation()
			control_target.set_state(control_target.STATES.ATTACK)
		else:
			if not control_target.is_attacking():
				control_target.set_state(control_target.STATES.MOVE)
				navigation.navigate_to_position(enemy.global_position)
	else:
		control_target.set_state(control_target.STATES.MOVE)

func get_nearest(node_array : Array) -> Node2D:
	var shortest_distance : float = INF
	var nearest : Node2D = null
	for n in node_array:
		var d = global_position.distance_squared_to(n.global_position)
		if d < shortest_distance:
			shortest_distance = d
			nearest = n
	return nearest

func has_attack_target() -> bool:
	return not attack_radius.targets.is_empty()

func _on_control_target_attacked() -> void:
	var enemy_to_attack = get_nearest(attack_radius.targets)
	if enemy_to_attack:
		var enemy_stats : Stats = enemy_to_attack.find_child("Stats")
		enemy_stats.take_damage(1)
