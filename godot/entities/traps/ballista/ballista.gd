class_name Ballista
extends Node2D

@onready var base = $Base
@onready var interaction_area = $InteractionArea
@onready var interact_display = $InteractCost

var interval : float = 1.0


func _ready() -> void:
	interaction_area.interacted.connect(_on_interaction_area_interacted)
	interact_display.hide()

func activate() -> void:
	# fire bolt
	start_interval()


# TIMERS -----------------------------------------------------------------------
func start_interval():
	get_tree().create_timer(interval).timeout.connect(_on_interval_timeout)


# SIGNALS ----------------------------------------------------------------------
func _on_interval_timeout() -> void:
	activate()

func _on_interaction_area_interacted() -> void:
	# rotate clockwise by 90 degrees
	pass
