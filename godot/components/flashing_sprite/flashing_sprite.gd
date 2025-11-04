extends Sprite2D

var flash_tween : Tween

var flash_duration_timer : SceneTreeTimer
var flash_interval_timer : SceneTreeTimer
var flashing := false : set = set_flashing

var flash_interval := 0.05
var flash_intensity := 0.8


func pulse(duration : float = 0.3, intensity : float = 0.8):
	if flash_tween != null and flash_tween.is_running():
		flash_tween.kill()
	flash_tween = create_tween()
	flash_tween.tween_method(set_color_override_amount, intensity, 0.0, duration)

func set_color_override_amount(value):
	material.set_shader_parameter("flash_amount", value)

func set_flashing(state):
	flashing = state
	set_color_override_amount(int(flashing) * flash_intensity)

func flash(duration : float):
	flash_duration_timer = get_tree().create_timer(duration)
	flash_duration_timer.timeout.connect(_on_flash_duration_timeout)
	flashing = true
	start_flash_interval()

func start_flash_interval():
	flash_interval_timer = get_tree().create_timer(flash_interval)
	flash_interval_timer.timeout.connect(_on_flash_interval_timeout)


# SIGNALS ----------------------------------------------------------------------
func _on_flash_duration_timeout():
	flashing = false

func _on_flash_interval_timeout():
	if flash_duration_timer.time_left > 0:
		flashing = not flashing
		start_flash_interval()
