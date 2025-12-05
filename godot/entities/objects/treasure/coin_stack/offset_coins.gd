extends Node2D

const MAX_NUDGES_CHAIN : int = 10

@export var offset_coin_texture : Texture

var rng = RandomNumberGenerator.new()

var nudge_threshold : float = 0.7
var flip_nudge_direction : bool = false
var nudges_left : int = MAX_NUDGES_CHAIN
var postpone_nudge : int = 2

func _ready() -> void:
	rng.randomize()

func create_coin() -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = offset_coin_texture
	s.offset.y = -1
	s.offset.x = -1 # center position
	if postpone_nudge:
		postpone_nudge -= 1
	else:
		if nudges_left:
			s.offset.x = -2 if flip_nudge_direction else 0
			nudges_left -= rng.randi_range(1, MAX_NUDGES_CHAIN - 1)
			nudges_left = max(nudges_left, 0)
		elif rng.randf() > nudge_threshold:
			nudges_left = MAX_NUDGES_CHAIN
			# swap nudge sides
			flip_nudge_direction = not flip_nudge_direction
	call_deferred("add_child", s)
	return s

func delete_above_position(y : float) -> void:
	for c : Node2D in get_children():
		if c.position.y < y:
			c.queue_free()
			postpone_nudge = 2

func coin_present_at_position(y : float) -> bool:
	for i in get_children():
		if i.position.y == y:
			return true
	return false
