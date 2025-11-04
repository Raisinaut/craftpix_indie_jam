extends Area2D

@export var target_group : String = ""
var targets : Array[Node2D] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body : Node2D) -> void:
	if body.is_in_group(target_group):
		targets.append(body)

func _on_body_exited(body : Node2D) -> void:
	if body.is_in_group(target_group) and targets.has(body):
		targets.erase(body)

func _on_body_exited_tree(body : Node2D) -> void:
	targets.erase(body)
