extends Node

signal currency_modified

@export var currency_icon_frames : Array[Texture] = []

var currency : int = 100 :
	set(value):
		currency = value
		currency_modified.emit(currency)

var resources : Dictionary = {
	"stash" : "currency",
}

var player : PlayerCharacter = null


# RESOURCE INFORMATION ---------------------------------------------------------
func get_resource_modify_signal_name(resource_name : String) -> String:
	var associated_variable = resources[resource_name]
	return associated_variable + "_modified"

func get_resource_value(resource_name : String):
	return get(resources[resource_name])

func get_resource_icon_frames(resource_name : String) -> Array:
	return get(resources[resource_name] + "_icon_frames")


# CHECKS -----------------------------------------------------------------------
func can_afford(amount : int) -> bool:
	return amount <= currency

func player_is_busy() -> bool:
	return player.is_busy()
