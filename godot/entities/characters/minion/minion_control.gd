extends Node2D

@export var control_target : MovingCharacter
@export var damage : int = 1

@onready var navigation = $Navigation
@onready var attack_radius = $AttackRadius
@onready var spawn_position = global_position

enum BEHAVIORS {
	PURSUE,
	RETREAT
}
var behavior = BEHAVIORS.PURSUE : set = set_behavior


func _ready() -> void:
	await control_target.ready
	control_target.attacked.connect(_on_control_target_attacked)
	control_target.stats.stamina_depleted.connect(_on_stamina_depleted)


# BEHAVIORS --------------------------------------------------------------------
func _process(_delta: float) -> void:
	match(behavior):
		BEHAVIORS.PURSUE:
			pursue()
		BEHAVIORS.RETREAT:
			retreat()

func set_behavior(state) -> void:
	behavior = state
	match(behavior):
		BEHAVIORS.RETREAT:
			navigation.navigation_finished.connect(_on_navigation_finished)
			# allow walking through other minions
			control_target.collision_shape.disabled = true
		BEHAVIORS.PURSUE:
			navigation.navigation_finished.disconnect(_on_navigation_finished)

func retreat():
	navigation.navigate_to_position(spawn_position)
	control_target.set_state(control_target.STATES.MOVE)

func pursue():
	var enemy = get_nearest(get_tree().get_nodes_in_group("enemy"))
	if enemy:
		if target_in_attack_range():
			navigation.stop_navigation()
			control_target.set_state(control_target.STATES.ATTACK)
		else:
			if not control_target.is_attacking():
				control_target.set_state(control_target.STATES.MOVE)
				navigation.navigate_to_position(enemy.global_position)
	else:
		control_target.set_state(control_target.STATES.MOVE)


# UTILITY ----------------------------------------------------------------------
func get_nearest(node_array : Array) -> Node2D:
	var shortest_distance : float = INF
	var nearest : Node2D = null
	for n in node_array:
		var d = global_position.distance_squared_to(n.global_position)
		if d < shortest_distance:
			shortest_distance = d
			nearest = n
	return nearest

func target_in_attack_range() -> bool:
	return not attack_radius.targets.is_empty()


# SIGNALS ----------------------------------------------------------------------
func _on_control_target_attacked() -> void:
	var enemy_to_attack = get_nearest(attack_radius.targets)
	if enemy_to_attack:
		var enemy_stats : Stats = enemy_to_attack.find_child("Stats")
		enemy_stats.take_damage(1)

func _on_stamina_depleted() -> void:
	behavior = BEHAVIORS.RETREAT

func _on_navigation_finished() -> void:
	control_target.queue_free()
