extends Node

var weapon_tiers_file = "res://data/Trove Keeper Weapon Tiers .json"
var weapon_tiers : Dictionary = {}

var data_folder := "res://resources/traps/"
var all_data : Array = []


func _ready() -> void:
	populate_data_list(all_data)
	weapon_tiers = parse_json(load_from_file(weapon_tiers_file))


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


# TIERS ------------------------------------------------------------------------

func reset_tiers(trap : BaseTrap) -> void:
	var scene = load(trap.scene_file_path)
	var data = get_trap_data_for_scene(scene)
	for p in data.upgradeable_properties:
		var property_name = data.get(p)
		if trap.get(property_name) != null:
			var tiers = get_tiers(data.get_type_string(), data.display_name, p)
			var max_idx = tiers.size() - 1
			var value = tiers[min(0, max_idx)]
			trap.set(property_name, value)
		else:
			#push_warning("Property \"" + property_name + "\" \
			#does not exist in " + str(trap))
			pass

func get_tier_value(tp : String, nm : String, pr: String, tier : int) -> Variant:
	return weapon_tiers[tp][nm][pr][tier]

func get_tiers(tp : String, nm : String, pr : String) -> Array:
	return weapon_tiers[tp][nm][pr]


# JSON -------------------------------------------------------------------------
func parse_json(json_string):
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		var data_type = typeof(data_received)
		var accepted_types = [TYPE_DICTIONARY, TYPE_ARRAY]
		if accepted_types.has(data_type):
			#print(data_received) # Prints array
			return data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func load_from_file(path : String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content
