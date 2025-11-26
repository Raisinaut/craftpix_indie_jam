extends CanvasLayer

@onready var button_container = %ButtonContainer
@onready var selection_indicator = $SelectionIndicator
@onready var erase_button = %EraseButton

@export var button_scene : PackedScene
@export var map : InteractableMap


func _ready() -> void:
	selection_indicator.hide()
	for d in TrapManager.all_data:
		add_button(d)
	connect_button_signals(erase_button)

func add_button(data : TrapData):
	var inst : TrapButton = button_scene.instantiate()
	button_container.call_deferred("add_child", inst)
	await inst.ready
	inst.data = data
	connect_button_signals(inst)
	map.add_trap_tile(data.scene)

func connect_button_signals(btn) -> void:
	btn.selected.connect(_on_button_selected.bind(btn))
	btn.focus_changed.connect(_on_button_focus_changed.bind(btn))


# SIGNALS ----------------------------------------------------------------------
func _on_button_selected(btn) -> void:
	if btn is TrapButton:
		map.selected_scene = TrapManager.find_data_idx(btn.data)
		if map.can_place():
			map.place_trap(btn.data.base_cost)
	else:
		if map.can_remove():
			var scene = map.get_highlighted_scene()
			var data : TrapData = TrapManager.get_trap_data_for_scene(scene)
			map.remove_trap(data.base_cost)

func _on_button_focus_changed(is_focused : bool, btn : SelectionButton) -> void:
	map.selected_scene = -1
	map.mode = map.MODES.DEFAULT
	if is_focused:
		selection_indicator.show()
		selection_indicator.update_corners(btn)
		match(btn.function):
			SelectionButton.FUNCTIONS.PLACE:
				map.mode = map.MODES.PLACE
				if not btn.disabled:
					map.selected_scene = TrapManager.find_data_idx(btn.data)
			SelectionButton.FUNCTIONS.ERASE:
				map.mode = map.MODES.REMOVE
	else:
		selection_indicator.hide()
