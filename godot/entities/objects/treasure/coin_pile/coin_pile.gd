extends StaticBody2D

@export var height_curve : Curve

@onready var stacks_container = $Stacks
@onready var spawn_position : Vector2 = position

var shake_tween : Tween = null

var stack_distribution : Dictionary[Node, float] = {}
var shake_offset = 1

func _ready() -> void:
	GameManager.stash = self
	GameManager.currency_modified.connect(_on_game_manager_currency_modified)
	GameManager.currency_lost.connect(shake)
	GameManager.currency_spent.connect(shake)
	for i in stacks_container.get_children():
		var distribution_amount = 1.0 - get_distance_scale(i.position)
		stack_distribution[i] = max(0.1, distribution_amount)
	stack_distribution.sort()
	update_stack_heights()

func _on_game_manager_currency_modified(currency : int) -> void:
	update_stack_heights()

func update_stack_heights() -> void:
	var c = GameManager.currency
	var max_c = GameManager.MAX_CURRENCY
	var percent_of_max_currency = c / float(max_c)
	var max_stack_height = 128
	for stack : CoinStack in stack_distribution.keys():
		var distribution_value = height_curve.sample(stack_distribution[stack])
		var scaled_max_height = max_stack_height * distribution_value
		var height = round(scaled_max_height * percent_of_max_currency)
		stack.height = height

func get_distance_scale(pos : Vector2) -> float:
	var distances = get_stack_distances()
	var closest = distances[0]
	var furthest = distances[-1]
	var this_distance : float = pos.length()
	return inverse_lerp(closest, furthest, this_distance)

func get_stack_distances() -> Array[float]:
	var distances : Array[float] = []
	for s in stacks_container.get_children():
		distances.append(s.position.length())
	distances.sort()
	return distances

func shake() -> void:
	if shake_tween: shake_tween.kill()
	shake_tween = create_tween()
	var shake_position_a = spawn_position + Vector2(shake_offset, 0)
	var shake_position_b = spawn_position + Vector2(-shake_offset, 0)
	shake_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(self, "position", shake_position_a, 0.02)
	shake_tween.set_ease(Tween.EASE_IN_OUT)
	shake_tween.tween_property(self, "position", shake_position_b, 0.04)
	shake_tween.set_ease(Tween.EASE_IN)
	shake_tween.tween_property(self, "position", spawn_position, 0.03)
