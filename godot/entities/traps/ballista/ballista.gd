class_name Ballista
extends BaseTrap

@onready var sprite = $Sprite
@onready var emitter = $Emitter

var direction := Vector2.RIGHT : set = set_direction


# OVERRIDES --------------------------------------------------------------------
func _on_activate() -> void:
	sprite.stop()
	sprite.play(get_directional_animation_name("fire"))
	emitter.emit()

func _on_deactivate() -> void:
	await sprite.animation_finished
	sprite.play(get_directional_animation_name("default"))

func _on_interact() -> void:
	direction = get_current_interaction_state()
	emitter.emission_direction = direction
	if sprite_is_firing():
		var last_frame = sprite.frame
		sprite.play(get_directional_animation_name("fire"))
		sprite.frame = last_frame
	else:
		sprite.play(get_directional_animation_name("default"))

func _connect_signals() -> void:
	sprite.animation_finished.connect(_on_sprite_animation_finished)


# UTILITY ----------------------------------------------------------------------
func get_directional_animation_name(anim_name : String) -> String:
	return anim_name + "_" + get_vector_as_string(direction)

func get_vector_as_string(vector : Vector2) -> String:
	var d : String = ""
	if abs(vector.x) > abs(vector.y):
		if vector.x >= 0:
			d = "right"
		else:
			d = "left"
	else:
		if vector.y >= 0:
			d = "down"
		else:
			d = "up"
	return d


# SETTERS ----------------------------------------------------------------------
func set_direction(value : Vector2) -> void:
	direction = value


# SIGNALS ----------------------------------------------------------------------
func _on_sprite_animation_finished() -> void:
	if sprite_is_firing():
		set_active(false)


# CHECKS -----------------------------------------------------------------------
func sprite_is_firing() -> bool:
	return sprite.animation.contains("fire")
