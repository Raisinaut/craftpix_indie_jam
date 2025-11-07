extends CanvasLayer

var data_folder := "res://resources/traps/"
var all_data : Array = []

@onready var button_container = %ButtonContainer

@export var button_scene : PackedScene
@export var map : InteractableMap


func _ready() -> void:
	populate_data_list(all_data)
	for d in all_data:
		add_button(d)

func add_button(data : TrapData):
	var inst : TrapButton = button_scene.instantiate()
	button_container.call_deferred("add_child", inst)
	await inst.ready
	inst.data = data
	inst.selected.connect(_on_button_selected.bind(inst))
	inst.focus_changed.connect(_on_button_focus_changed.bind(inst))


# SIGNALS ----------------------------------------------------------------------
func _on_button_selected(btn : TrapButton) -> void:
	#print("selected:  ", btn.data.display_name)
	map.selected_scene = find_data_idx(btn)
	if map.can_place():
		GameManager.currency -= btn.data.base_cost
		map.place_trap()

func _on_button_focus_changed(is_focused : bool, btn : TrapButton) -> void:
	if is_focused:
		map.selected_scene = find_data_idx(btn)
	else:
		map.selected_scene = -1

func find_data_idx(btn : TrapButton) -> int:
	return all_data.find(btn.data)

# DATA GATHERING ---------------------------------------------------------------
func populate_data_list(data_list : Array):
	# clear previous list contents
	data_list.clear()
	
	# open the directory
	var dir = DirAccess.open(data_folder)
	var list : Array = dir.get_files()
	
	for file_name in list:
		# exclude .import files
		if file_name.ends_with(".import"):
			list.erase(file_name)
			continue
		
		# load and add all other files
		var file_path = data_folder + file_name
		var item_data = load(file_path)
		if item_data:
			data_list.append(item_data)
		else:
			push_error("Could not load item from ", file_path)
