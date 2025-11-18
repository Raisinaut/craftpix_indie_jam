extends Node

@export var coin_scene : PackedScene

var y_sort_root : Node2D = null


func spawn_coin(pos : Vector2, quantity : int = 1) -> void:
	if not y_sort_root:
		return
	for i in quantity:
		var c : Node2D = coin_scene.instantiate()
		y_sort_root.call_deferred("add_child", c)
		c.global_position = pos
