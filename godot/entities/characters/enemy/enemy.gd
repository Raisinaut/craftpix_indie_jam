class_name Enemy
extends MovingCharacter


func sync_animation_to_actual_velocity() -> void:
	var anim_prefix = ""
	if actual_velocity == Vector2.ZERO:
		anim_prefix = "idle"
	else:
		anim_prefix = "walk"
	play_animation_in_facing_direction(anim_prefix, actual_velocity)

func move() -> void:
	sync_animation_to_actual_velocity()
	sync_sprite_flip(actual_velocity)
