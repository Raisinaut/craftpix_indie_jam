extends Node2D

@export var emission_scene : PackedScene
@export var emission_speed : int

var emission_direction := Vector2.RIGHT

func emit() -> void:
	spawn_scene(emission_scene)

func spawn_scene(scene : PackedScene) -> void:
	var inst : LinearProjectile = scene.instantiate()
	EntityManager.y_sort_root.call_deferred("add_child", inst)
	inst.global_position = global_position
	inst.move_direction = emission_direction
	inst.move_speed = emission_speed
