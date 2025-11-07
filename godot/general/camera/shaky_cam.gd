class_name ShakyCamera
extends Camera2D

@export var follow_speed = 10

@onready var screen_shake = $ScreenShake
@export var target : Node2D


func shake() -> void:
	screen_shake.start(0.3, 30, 10, 0)

func _process(delta: float) -> void:
	if target:
		follow_target(delta)

func follow_target(delta : float):
	var p = global_position
	var t = target.global_position
	global_position = lerp(p, t, follow_speed * delta)
