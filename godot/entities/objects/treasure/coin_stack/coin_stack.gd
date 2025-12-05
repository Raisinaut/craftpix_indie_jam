class_name CoinStack
extends Node2D

@onready var middle = $Middle
@onready var cap = $Cap
@onready var coins = $Coins

var height : int = 0 : set = set_height
var offset_minimum_height : int = 2
var cap_offset : int = 1

func _ready() -> void:
	height = 0

func set_height(value : int) -> void:
	var last_height = height
	height = value
	update_middle_length()
	update_cap_position()
	visible = height > 0
	while last_height < height:
		var instance_height = -last_height + offset_minimum_height
		var coin = coins.create_coin()
		coin.position.y = instance_height
		last_height += 1
	coins.delete_above_position(-height + offset_minimum_height + cap_offset)

func update_middle_length() -> void:
	middle.region_rect.size.y = height
	middle.offset.y = -height / 2.0

func update_cap_position() -> void:
	cap.position.y = -height + cap_offset
