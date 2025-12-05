@tool
extends Sprite2D

@export var size : int = 1 : set = set_size

func set_size(value : int) -> void:
	value = min(value, hframes)
	size = value
	frame = size - 1
