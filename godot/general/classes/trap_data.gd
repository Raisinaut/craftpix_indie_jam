class_name TrapData
extends Resource

## The name used to represent the trap within the UI.
@export var display_name : String
## The texture used to represent the trap within the UI.
@export var icon : Texture
## The game object used within the game world.
@export var scene : PackedScene

@export_category("STATS")
@export var base_cost : int
@export var base_interval : float
## A duration of 0 will mean the trap's effect is a one-shot.
@export var base_duration : float = 0.0
