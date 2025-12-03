class_name TrapStats
extends Resource

signal tier_changed(property, value)

enum CATEGORIES  {
	TOWER
}

@export var category : CATEGORIES = CATEGORIES.TOWER
@export var special_1 : String = ""
@export var special_2 : String = ""

var tiers : Dictionary[String, int] = {
	"interval"  : 1,
	"duration"  : 1,
	"special_1" : 1,
	"special_2" : 1
}

func set_tier(property : String, value) -> void:
	tiers[property] = value
	var variable_name = property
	if variable_name.has("special"):
		variable_name = get(property)
	tier_changed.emit(variable_name, value)
