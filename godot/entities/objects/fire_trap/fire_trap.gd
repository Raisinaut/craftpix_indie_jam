class_name Trap
extends Node2D

@onready var base = $Base
@onready var generation = $Generation
@onready var fireballs = $Fireballs
@onready var interaction_area = $InteractionArea
@onready var interact_display = $InteractCost

var active : bool = false : set = set_active
var initialized : bool = false
var interval : float = 1.0
var duration : float = 2.0

func _ready() -> void:
	fireballs.fully_retracted.connect(_on_fireballs_fully_contracted)
	interaction_area.interacted.connect(_on_interaction_area_interacted)
	interact_display.hide()
	await delay()
	initialized = true
	start_duration()

func _process(delta: float) -> void:
	if initialized:
		interact_display.visible = interaction_area.can_interact()

func delay():
	await get_tree().create_timer(0.05).timeout

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

func _on_interaction_area_interacted() -> void:
	fireballs.flip_rotation_direction()
