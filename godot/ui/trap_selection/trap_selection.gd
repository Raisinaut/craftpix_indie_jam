extends CanvasLayer

var data_folder := "res://resources/traps/"
var all_data : Array = []

@onready var button_container = %ButtonContainer
@onready var selection_indicator = $SelectionIndicator
@onready var erase_button = %EraseButton

@export var button_scene : PackedScene
@export var map : InteractableMap


func _ready() -> void:
	selection_indicator.hide()
	populate_data_list(all_data)
	for d in all_data:
		add_button(d)
	connect_button_signals(erase_button)

func add_button(data : TrapData):
	var inst : TrapButton = button_scene.instantiate()
	button_container.call_deferred("add_child", inst)
	await inst.ready
	inst.data = data
	connect_button_signals(inst)

func connect_button_signals(btn) -> void:
	btn.selected.connect(_on_button_selected.bind(btn))
	btn.focus_changed.connect(_on_button_focus_changed.bind(btn))


# SIGNALS ----------------------------------------------------------------------
func _on_button_selected(btn) -> void:
	if btn is TrapButton:
		map.selected_scene = find_data_idx(btn.data)
		if map.can_place():
			map.place_trap(btn.data.base_cost)
	else:
		if map.can_remove():
			var data : TrapData = get_trap_data_for_scene(map.get_highlighted_scene())
			map.remove_trap(data.base_cost)

func _on_button_focus_changed(is_focused : bool, btn : SelectionButton) -> void:
	map.selected_scene = -1
	map.mode = map.MODES.PLACE
	if is_focused:
		selection_indicator.show()
		selection_indicator.update_corners(btn)
		match(btn.function):
			SelectionButton.FUNCTIONS.PLACE:
				if not btn.disabled:
					map.selected_scene = find_data_idx(btn.data)
			SelectionButton.FUNCTIONS.ERASE:
				map.mode = map.MODES.REMOVE
	else:
		selection_indicator.hide()


# DATA -------------------------------------------------------------------------
func find_data_idx(data : TrapData) -> int:
	return all_data.find(data)

func get_trap_data_for_scene(trap_scene) -> TrapData:
	var data = null
	for d : TrapData in all_data:
		if d.scene == trap_scene:
			data = d
			break
	return data

func populate_data_list(data_list : Array):
	# clear previous list contents
	data_list.clear()
	
	# open the directory
	var dir = DirAccess.open(data_folder)
	var list : Array = dir.get_files()
	
	for file_name : String in list:
		# exclude .import files
		if file_name.ends_with(".import"):
			list.erase(file_name)
			continue
		
		# trim .remap from file names (might only be relevent for web builds)
		file_name = file_name.trim_suffix(".remap")
		
		# load and add all other files
		var file_path = data_folder + file_name
		var item_data = ResourceLoader.load(file_path)
		if item_data:
			data_list.append(item_data)
		else:
			push_error("Could not load item from ", file_path)
