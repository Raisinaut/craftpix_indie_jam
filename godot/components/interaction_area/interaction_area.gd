class_name InteractionArea
extends Area2D

signal interacted

@export var interact_input : String = "interact"
@export var group_requirement : String

var nodes_in_area : Array = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body : Node2D) -> void:
	if body.is_in_group("player"):
		nodes_in_area.append(body)

func _on_body_exited(body : Node2D) -> void:
	if body.is_in_group("player"):
		nodes_in_area.erase(body)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(interact_input) and can_interact():
		interacted.emit()

func can_interact() -> bool:
	return not nodes_in_area.is_empty()
