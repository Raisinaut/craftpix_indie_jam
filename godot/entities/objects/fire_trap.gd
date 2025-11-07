extends Node2D

var active : bool = false : set = set_active

@onready var base = $Base
@onready var generation = $Generation

var interval : float = 2.0
var duration : float = 1.0


func _ready() -> void:
	start_duration()

func set_active(state : bool) -> void:
	active = state
	if active:
		_activate()
	else:
		_deactivate()

func _activate():
	#sprite.play("active")
	generation.visible = true
	# TODO activate hitbox

func _deactivate():
	#sprite.play("default")
	generation.visible = false
	# TODO deactivate hitbox


# TIMERS -----------------------------------------------------------------------
func start_interval():
	get_tree().create_timer(interval).timeout.connect(_on_interval_timeout)

func start_duration():
	get_tree().create_timer(duration).timeout.connect(_on_duration_timeout)
	set_active(true)


# SIGNALS ----------------------------------------------------------------------
func _on_interval_timeout() -> void:
	start_duration()

func _on_duration_timeout() -> void:
	start_interval()
	set_active(false)
