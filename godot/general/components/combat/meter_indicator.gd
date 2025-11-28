extends TextureProgressBar

@export var stats : Stats
@export var tracking_stat : String = "hp"

@onready var visibility_timer : Timer = $VisiblityTimer
@onready var progress_cap : ColorRect = $ProgressCap

var fade_tween : Tween = null

func _ready() -> void:
	hide()
	value_changed.connect(_on_value_changed)
	visibility_timer.timeout.connect(_on_visibility_timer_timeout)
	stats.connect(tracking_stat + "_changed", _on_stat_changed)

func _on_stat_changed(_hp) -> void:
	show()
	fade(1.0, 0)
	value = Callable(stats, "get_" + tracking_stat + "_percent").call()
	#visibility_timer.start()

func _on_visibility_timer_timeout() -> void:
	fade(0.0, 1.0)

func _on_value_changed(new_value : float) -> void:
	var min_cap_pos : float = 0.0
	var max_cap_pos : float = size.x - 1
	progress_cap.position.x = lerp(min_cap_pos, max_cap_pos, new_value)

func fade(alpha : float, duration) -> void:
	if fade_tween: fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", alpha, duration)
