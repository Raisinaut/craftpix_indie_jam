extends Node2D

@export var minion_scene : PackedScene
@export var use_cost : int = 10

@onready var door = $Door
@onready var interaction_area = $InteractionArea
@onready var spawn_location = $SpawnLocation
@onready var cost_display = $CostDisplay


func _ready() -> void:
	cost_display.set_cost(use_cost)
	# SIGNAL SETUP
	interaction_area.interacted.connect(_on_interaction_area_interacted)
	door.fully_opened.connect(_on_door_fully_opened)

func _process(_delta: float) -> void:
	cost_display.visible = interaction_area.can_interact()

func spawn() -> Node2D:
	var inst = minion_scene.instantiate()
	inst.global_position.y += 6
	inst.global_position += Vector2(randf(), randf()) * 2
	call_deferred("add_child", inst)
	return inst

func use() -> void:
	if not door.is_closed():
		return
	if GameManager.can_afford(use_cost):
		GameManager.spend_currency(use_cost)
		print("door used")
		door.open()


# SIGNALS ----------------------------------------------------------------------
func _on_interaction_area_interacted() -> void:
	use()

func _on_door_fully_opened() -> void:
	spawn()
	print("spawned enemy")
	door.close()
