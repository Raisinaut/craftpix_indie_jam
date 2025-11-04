extends CanvasLayer

@export var resource_display_scene : PackedScene

@onready var resource_list = %ResourceList

func _ready() -> void:
	for res in GameManager.resources.keys():
		add_resource_display(res)


func add_resource_display(resource_name : String) -> void:
	var inst : ResourceDisplay = resource_display_scene.instantiate()
	resource_list.call_deferred("add_child", inst)
	await inst.ready
	inst.resource_name = resource_name.to_upper()
	inst.resource_amount = GameManager.get_resource_value(resource_name)
	inst.icon_texture_frames = GameManager.get_resource_icon_frames(resource_name)
	var modify_signal = GameManager.get_resource_modify_signal_name(resource_name)
	GameManager.connect(modify_signal, inst.set_resource_amount)
