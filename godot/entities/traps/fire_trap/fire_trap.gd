class_name Trap
extends BaseTrap

@onready var base = $Base
@onready var generation = $Generation
@onready var fireballs = $Fireballs


# OVERRIDES --------------------------------------------------------------------
func _on_activate() -> void:
	generation.visible = true
	fireballs.populate_entites()
	fireballs.expand_entities()
	fireballs.show()

func _on_deactivate() -> void:
	generation.visible = false
	fireballs.retract_entities()

func _on_interact() -> void:
	fireballs.clockwise_rotation = get_current_interaction_state()

func _connect_signals() -> void:
	fireballs.fully_retracted.connect(_on_fireballs_fully_contracted)


# SIGNALS ----------------------------------------------------------------------
func _on_fireballs_fully_contracted() -> void:
	fireballs.hide()
