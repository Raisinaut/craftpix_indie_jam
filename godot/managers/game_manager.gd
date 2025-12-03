extends Node

const MAX_CURRENCY = 9999

signal currency_modified
signal currency_lost
signal currency_spent
signal currency_gained

@export var currency_icon_frames : Array[Texture] = []

var currency : int = 20 : set = set_currency
var resources : Dictionary = {
	"stash" : "currency",
}

# TRACKED NODES
var player : PlayerCharacter = null
var stash : Node2D = null

# CHEATS
var infinite_money : bool = false : set = set_infinite_money


# CURRENCY MODIFCATION ---------------------------------------------------------
func set_currency(value : int) -> void:
	currency = max(0, value)
	if infinite_money:
		currency = MAX_CURRENCY
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


# CHEATS -----------------------------------------------------------------------
func set_infinite_money(state : bool) -> void:
	infinite_money = state
	if infinite_money:
		currency = MAX_CURRENCY
	else:
		currency = 100

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


# NODE ACCESS ------------------------------------------------------------------
func get_stash_position() -> Vector2:
	if stash:
		return stash.global_position
	else:
		push_warning("No stash node stored. Returned Vector2.ZERO.")
		return Vector2.ZERO
