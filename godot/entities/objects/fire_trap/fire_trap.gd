class_name Trap
extends Node2D

var active : bool = false : set = set_active

@onready var base = $Base
@onready var generation = $Generation
@onready var fireballs = $Fireballs

var interval : float = 1.0
var duration : float = 2.0


func _ready() -> void:
	start_duration()
	fireballs.fully_retracted.connect(_on_fireballs_fully_contracted)

func set_active(state : bool) -> void:
	active = state
	if active:
		_activate()
	else:
		_deactivate()

func _activate():
	generation.visible = true
	fireballs.populate_entites()
	fireballs.expand_entities()
	fireballs.show()

func _deactivate():
	generation.visible = false
	fireballs.retract_entities()


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

func _on_fireballs_fully_contracted() -> void:
	fireballs.hide()
