@tool
extends Sprite2D

@export_range(1, 2) var size : int = 1 : set = set_size

func set_size(value : int) -> void:
	size = value
	frame = size - 1
