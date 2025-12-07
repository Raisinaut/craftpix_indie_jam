extends TextureProgressBar

@export var signal_node : Node
@export var update_signal : String = ""

@onready var visibility_timer : Timer = $VisiblityTimer
@onready var progress_cap : ColorRect = $ProgressCap

var fade_tween : Tween = null
var force_hide : bool = false

func _ready() -> void:
	fade(0.0, 0.0)
	value_changed.connect(_on_value_changed)
	visibility_timer.timeout.connect(_on_visibility_timer_timeout)
	if signal_node and update_signal:
		signal_node.connect(update_signal, _update)
	GameManager.hide_meters_changed.connect(_on_game_manager_hide_meters_changed)

func _update(new_value) -> void:
	visible = not force_hide
	fade(1.0, 0)
	#visibility_timer.start()
	set_progress(new_value)

func set_progress(p : float) -> void:
	value = clamp(p, 0.0, 1.0)

func _on_visibility_timer_timeout() -> void:
	fade(0.0, 1.0)

func _on_value_changed(_new_value : float) -> void:
	update_progress_cap_position()

func update_progress_cap_position() -> void:
	var min_cap_pos : float = 0.0
	var max_cap_pos : float = size.x - 1
	progress_cap.position.x = lerp(min_cap_pos, max_cap_pos, value)

func fade(alpha : float, duration) -> void:
	if fade_tween: fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", alpha, duration)

func _on_game_manager_hide_meters_changed(state : bool):
	force_hide = state
	visible = not force_hide
