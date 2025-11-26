extends Node

var data_folder := "res://resources/traps/"
var all_data : Array = []


func _ready() -> void:
	populate_data_list(all_data)


# TRAP-SPECFIC -----------------------------------------------------------------
func find_data_idx(data : TrapData) -> int:
	return all_data.find(data)

func get_trap_data_for_scene(trap_scene) -> TrapData:
	var data = null
	for d : TrapData in all_data:
		if d.scene == trap_scene:
			data = d
			break
	return data


# GENERAL ----------------------------------------------------------------------
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
