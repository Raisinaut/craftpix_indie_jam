# Detected by HurtBox
class_name HitBox
extends Area2D

@warning_ignore("unused_signal")
signal detected(hurtbox) # not ideal, but signal is triggered from the hurtbox class >_>

@export var damage := 1
@export var knockback := 0

var disabled := false : set = set_disabled
var knockback_direction := Vector2.ZERO


func _init() -> void:
	setup_collision()

func setup_collision():
	collision_layer = int(pow(2, 7-1))
	collision_mask = int(pow(2, 8-1))

func set_disabled(state):
	disabled = state
	set_deferred("monitorable", not disabled)

func get_collision_shape() -> CollisionShape2D:
	for c in get_children():
		if c is CollisionShape2D:
			return c
	return null
