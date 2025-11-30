class_name Trap
extends Node2D

@export var interaction_states : Array[Variant] = []

## The time between activations
@export_range(0, 10, 1, "or_greater") var active_interval : float = 1.0
## A duration of zero results in the duration being skipped.
@export_range(0, 10, 1, "or_greater") var active_duration : float = 2.0
## Sets enabled to true after the initialization delay
@export var auto_enable : bool = true

@onready var base = $Base
@onready var generation = $Generation
@onready var fireballs = $Fireballs
@onready var interaction_area = $InteractionArea
@onready var interact_display = $InteractCost

var interaction_state_idx = 0 : set = set_interaction_state_idx
var initialization_delay : float = 0.05
var active : bool = false : set = set_active
var enabled : bool = false : set = set_enabled


func _ready() -> void:
	_connect_signals()
	interact_display.hide()
	await delay(initialization_delay)
	if auto_enable:
		enabled = true

func _process(delta: float) -> void:
	if enabled:
		interact_display.visible = interaction_area.can_interact()

func delay(time : float):
	await get_tree().create_timer(initialization_delay).timeout

func get_current_interaction_state() -> Variant:
	return interaction_states[interaction_state_idx]


# SETTERS ----------------------------------------------------------------------
func set_interaction_state_idx(value : int) -> void:
	value = wrapi(value, 0, interaction_states.size())
	interaction_state_idx = value
	interact_display.update_action_icon(interaction_state_idx)

func set_active(state : bool) -> void:
	active = state
	if active:
		_activate()
	else:
		_deactivate()

func set_enabled(state : bool) -> void:
	enabled = state
	if enabled:
		start_active_duration()


# OVERRIDES --------------------------------------------------------------------
func _activate():
	generation.visible = true
	fireballs.populate_entites()
	fireballs.expand_entities()
	fireballs.show()

func _deactivate():
	generation.visible = false
	fireballs.retract_entities()

func _interact() -> void:
	interaction_state_idx += 1
	fireballs.clockwise_rotation = get_current_interaction_state()

func _connect_signals() -> void:
	fireballs.fully_retracted.connect(_on_fireballs_fully_contracted)
	interaction_area.interacted.connect(_on_interaction_area_interacted)


# TIMERS -----------------------------------------------------------------------
func start_active_interval():
	set_active(false)
	var t = get_tree().create_timer(active_interval)
	t.timeout.connect(_on_active_interval_timeout)

func start_active_duration():
	set_active(true)
	var t = get_tree().create_timer(active_duration)
	t.timeout.connect(_on_active_duration_timeout)


# SIGNALS ----------------------------------------------------------------------
func _on_active_interval_timeout() -> void:
	start_active_duration()

func _on_active_duration_timeout() -> void:
	start_active_interval()

func _on_fireballs_fully_contracted() -> void:
	fireballs.hide()

func _on_interaction_area_interacted() -> void:
	_interact()
