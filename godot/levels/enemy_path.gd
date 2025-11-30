extends Path2D

signal path_end_reached

@export var enemy_scene : PackedScene

@export var spawn_interval : float = 6.0 # 6.0 for easy

var movers : Array[PathFollow2D] = []

var max_interval = 6.0
var min_interval = 0.5

var interval_reduction_rate : float = 0.05


func _ready() -> void:
	start_spawn_timer()
	path_end_reached.connect(_on_path_end_reached)

func start_spawn_timer() -> void:
	get_tree().create_timer(spawn_interval).timeout.connect(_on_spawn_timer_timeout)

func _process(delta: float) -> void:
	for i in movers:
		var enemy : Enemy = i.get_child(0)
		var next_progress = i.progress + enemy.base_speed * delta
		if i.progress_ratio != 1.0:
			i.progress = next_progress
		else:
			path_end_reached.emit()
			movers.erase(i)
			i.queue_free()
	#spawn_interval -= interval_reduction_rate * delta
	#spawn_interval = clamp(spawn_interval, min_interval, max_interval)

func add_follower() -> void:
	# create new path
	var follower = PathFollow2D.new()
	follower.rotates = false
	follower.loop = false
	call_deferred("add_child", follower)
	await follower.ready
	# attach instance to path
	var inst : Enemy = enemy_scene.instantiate()
	follower.call_deferred("add_child", inst)
	inst.died.connect(_on_inst_died.bind(follower))
	movers.append(follower)

func get_leading_entity():
	if get_children().size() > 0:
		return movers[0].get_child(0)
	return null


# SIGNALS ----------------------------------------------------------------------
func _on_inst_died(follower) -> void:
	EntityManager.spawn_coin(follower.global_position)
	movers.erase(follower)

func _on_path_end_reached() -> void:
	GameManager.lose_currency(1)

func _on_spawn_timer_timeout() -> void:
	add_follower()
	start_spawn_timer()
