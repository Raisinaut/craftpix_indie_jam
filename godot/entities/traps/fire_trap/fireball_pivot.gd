class_name EntityRing
extends Node2D

signal fully_expanded
signal fully_retracted

@export var entity_count : int = 2
@export var entity_scene : PackedScene
@export var rotations_per_second : float = 0.5
@export var rotate_clockwise : bool = true
@export var expand_distance : float = 16
@export var expand_time : float = 0.25

var entity_distance = 0.0 : set = set_entity_distance

var distance_tween : Tween


func _process(delta: float) -> void:
	spin(delta)

func spin(delta : float):
	var speed = (1 / rotations_per_second)
	var rotation_amount = (2 * PI) / speed * delta
	if not rotate_clockwise:
		rotation_amount *= -1
	rotate(rotation_amount)

func flip_rotation_direction() -> void:
	rotate_clockwise = not rotate_clockwise

# ENTITY CONTROL ---------------------------------------------------------------
func populate_entites() -> void:
	clear_entities()
	var final_entity : Node2D = null
	for i in entity_count:
		var inst = entity_scene.instantiate()
		call_deferred("add_child", inst)
		if i == entity_count - 1:
			final_entity = inst
	# reset entity positions once all are present
	await final_entity.tree_entered
	update_circle_positions()

func clear_entities() -> void:
	for i in get_children():
		i.queue_free()

func update_circle_positions() -> void:
	for i in get_child_count():
		var entity = get_child(i)
		entity.position = Vector2.from_angle(get_index_angle(i))

func set_entity_distance(value) -> void:
	entity_distance = value
	for entity in get_children():
		var p = entity.position.normalized() * entity_distance
		entity.position = p

func expand_entities():
	if distance_tween:
		distance_tween.kill()
	distance_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	distance_tween.tween_property(self, "entity_distance", expand_distance, expand_time)
	distance_tween.finished.connect(fully_expanded.emit)

func retract_entities():
	if distance_tween:
		distance_tween.kill()
	distance_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	distance_tween.tween_property(self, "entity_distance", 0, expand_time)
	distance_tween.finished.connect(fully_retracted.emit)


# UTILITY ----------------------------------------------------------------------
func get_index_angle(index : int, max_index = get_child_count()):
	return lerp(0.0, 2 * PI, index / float(max_index))

func at_entity_cap() -> bool:
	return get_child_count() == entity_count
