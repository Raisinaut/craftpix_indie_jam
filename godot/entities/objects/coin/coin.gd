extends Node2D


@onready var detection = $Detection
@onready var animator = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var flash_control = $Sprite2D/FlashControl
@onready var shadow = $Shadow
@onready var sparkle_particles = $CPUParticles2D

var pos_tween : Tween
var fade_tween : Tween


func _ready() -> void:
	bounce()
	sparkle_particles.emitting = false
	detection.body_entered.connect(_on_detection_body_entered)

func _on_detection_body_entered(body : Node2D) -> void:
	disable_detection()
	flash_sprite()
	elevate()
	await move_to_stash()
	GameManager.gain_currency(1)
	set_sprite_visibility(false)
	particle_safe_free()


# ANIMATION --------------------------------------------------------------------
func elevate() -> void:
	z_index = 100 # put above everything else
	animator.play("RESET") # cancel out active animations
	sparkle_particles.emitting = true # emit trail
	fade_element(shadow, 0.25) # fade the shadow

func bounce() -> Signal:
	animator.play("bounce")
	var displacement = get_random_vector(14, 18)
	var bounce_pos = round(global_position + displacement)
	var duration = animator.get_animation("bounce").length
	return tween_to_position(bounce_pos, duration, Tween.EASE_OUT).finished

func move_to_stash() -> Signal:
	var stash_pos = GameManager.get_stash_position()
	var stash_dist = global_position.distance_to(stash_pos)
	var duration = remap(stash_dist, 0.0, 200.0, 0.2, 0.8)
	return tween_to_position(stash_pos, duration, Tween.EASE_IN).finished

func fade_element(node : Node2D, duration : float, reverse := false) -> void:
	if fade_tween:
		fade_tween.kill()
	var alpha_value = int(reverse)
	fade_tween = create_tween()
	fade_tween.tween_property(node, "modulate:a", alpha_value, duration)

func flash_sprite() -> void:
	flash_control.flash(0.1)

# UTILITY ----------------------------------------------------------------------
func disable_detection():
	detection.set_deferred("monitoring", false)

func particle_safe_free() -> void:
	sparkle_particles.emitting = false
	await get_tree().create_timer(sparkle_particles.lifetime).timeout
	queue_free()

func tween_to_position(
pos : Vector2, duration : float, ease_type : Tween.EaseType) -> Tween:
	if pos_tween: pos_tween.kill()
	pos_tween = create_tween()
	pos_tween.set_ease(ease_type).set_trans(Tween.TRANS_SINE)
	pos_tween.tween_property(self, "global_position", pos, duration)
	return pos_tween

func get_random_vector(min_length : float, max_length : float) -> Vector2:
	var angle = randf_range(0.0, 2 * PI)
	var direction = Vector2.from_angle(angle)
	var length = randf_range(min_length, max_length)
	return direction * length

func set_sprite_visibility(state : bool) -> void:
	sprite.visible = state
	shadow.visible = state
