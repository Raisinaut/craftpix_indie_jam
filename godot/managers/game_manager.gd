extends Node

signal currency_modified
signal currency_lost
signal currency_spent
signal currency_gained

@export var currency_icon_frames : Array[Texture] = []

var currency : int = 20 : set = set_currency
var resources : Dictionary = {
	"stash" : "currency",
}

var player : PlayerCharacter = null
var stash : Node2D = null


# CURRENCY MODIFCATION ---------------------------------------------------------
func set_currency(value : int) -> void:
	currency = max(0, value)
	currency_modified.emit(currency)

func gain_currency(amount : int) -> void:
	currency += amount
	currency_gained.emit()

func lose_currency(amount : int) -> void:
	currency -= amount
	currency_lost.emit()

func spend_currency(amount : int) -> void:
	currency -= amount
	currency_spent.emit()


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


# NODE ACCESS ------------------------------------------------------------------
func get_stash_position() -> Vector2:
	if stash:
		return stash.global_position
	else:
		push_warning("No stash node stored. Returned Vector2.ZERO.")
		return Vector2.ZERO
