extends Path2D

@export var enemy_scene : PackedScene

@export var spawn_interval : float = 2.0

var movers : Array[PathFollow2D] = []


func _ready() -> void:
	start_spawn_timer()

func start_spawn_timer() -> void:
	get_tree().create_timer(spawn_interval).timeout.connect(_on_spawn_timer_timeout)

func _process(delta: float) -> void:
	for i in movers:
		var enemy : Enemy = i.get_child(0)
		i.progress += enemy.base_speed * delta

func add_follower() -> void:
	# create new path
	var path = PathFollow2D.new()
	path.rotates = false
	call_deferred("add_child", path)
	await path.ready
	# attach instance to path
	var inst : Enemy = enemy_scene.instantiate()
	path.call_deferred("add_child", inst)
	inst.died.connect(_on_inst_died.bind(path))
	movers.append(path)

func _on_inst_died(path) -> void:
	movers.erase(path)

func _on_spawn_timer_timeout() -> void:
	add_follower()
	start_spawn_timer()
