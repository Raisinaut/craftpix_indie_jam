extends TextureProgressBar

@export var stats : Stats

@onready var visibility_timer : Timer = $VisiblityTimer

var fade_tween : Tween = null

func _ready() -> void:
	hide()
	visibility_timer.timeout.connect(_on_visibility_timer_timeout)
	stats.hp_changed.connect(_on_stats_hp_changed)

func _on_stats_hp_changed(_hp) -> void:
	show()
	fade(1.0, 0)
	value = stats.get_hp_percent()
	visibility_timer.start()

func _on_visibility_timer_timeout() -> void:
	fade(0.0, 1.0)

func fade(alpha : float, duration) -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", alpha, duration)
