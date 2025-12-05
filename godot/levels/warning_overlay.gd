extends CanvasLayer

const MAX_WARNING_AMOUNT = 1

@onready var color_vignette : ColorRect = $ColorVignette

@export var warning_curve : Curve

var warning_amount = 0.0
var warning_raise_rate = 0.5
var warning_lower_rate = 0.5
var raise_tween_duration : float = 0.2
var raise_tween : Tween


func _ready() -> void:
	GameManager.currency_lost.connect(_on_game_manager_currency_lost)
	setup_vignette()

func _on_game_manager_currency_lost() -> void:
	increase_warning()

func _process(delta : float) -> void:
	set_vignette_opacity(warning_curve.sample(warning_amount))
	if not is_raising():
		decay_warning(delta)

func decay_warning(delta : float) -> void:
	warning_amount -= warning_lower_rate * delta
	warning_amount = max(0.0, warning_amount)

func setup_vignette() -> void:
	color_vignette.show()
	set_vignette_opacity(0.0)

func set_vignette_opacity(value : float) -> void:
	var shader_mat : ShaderMaterial = color_vignette.material
	shader_mat.set_shader_parameter("vignette_opacity", value)

func increase_warning() -> void:
	var end_amount = warning_amount + warning_raise_rate
	end_amount = min(end_amount, MAX_WARNING_AMOUNT)
	if raise_tween: raise_tween.kill()
	raise_tween = create_tween()
	raise_tween.tween_property(self, "warning_amount", end_amount, 0.15)

func is_raising() -> bool:
	return raise_tween and raise_tween.is_running()
