class_name InteractionArea
extends Area2D

signal interacted
signal can_interact_changed(state : bool)

@export var interact_input : String = "interact"
@export var group_requirement : String = "player"

var nodes_in_area : Array = []
var can_interact : bool = false : set = set_can_interact

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	update_can_interact()
	poll_interaction()

func poll_interaction() -> void:
	if Input.is_action_just_pressed(interact_input) and can_interact:
		interacted.emit()


# SETTERS ----------------------------------------------------------------------
func set_can_interact(state : bool) -> void:
	if can_interact != state:
		can_interact = state
		can_interact_changed.emit(can_interact)


# CHECKS -----------------------------------------------------------------------
func update_can_interact() -> void:
	var has_player = not nodes_in_area.is_empty()
	var player_not_busy = not GameManager.player_is_busy()
	can_interact = has_player and player_not_busy


# SIGNALS ----------------------------------------------------------------------
func _on_body_entered(body : Node2D) -> void:
	if body.is_in_group(group_requirement):
		nodes_in_area.append(body)

func _on_body_exited(body : Node2D) -> void:
	if body.is_in_group(group_requirement):
		nodes_in_area.erase(body)
