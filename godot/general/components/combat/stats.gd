class_name Stats
extends Node2D

signal hp_depleted
signal hp_gained
signal hp_lost
signal hp_changed(hp_percent)

signal stamina_changed
signal stamina_depleted

@export var max_hp : int = 100
@export var max_stamina : int = 10
@export var unlimited_stamina : bool = true

@onready var hp : float = max_hp : set = set_hp # set onready to keep export value
@onready var stamina : float = max_stamina : set = set_stamina


# HP MANAGEMENT ----------------------------------------------------------------
func set_hp(value) -> void:
	value = clamp(value, 0, max_hp)
	if hp == value:
		return
	
	# Set hp
	var original_hp = hp
	hp = value
	
	# Emit signals
	if value < original_hp:
		hp_lost.emit()
	elif value > original_hp:
		hp_gained.emit()
	hp_changed.emit(get_hp_percent())
	
	if hp <= 0:
		hp_depleted.emit()

func get_hp_percent() -> float:
	return hp / float(max_hp)

func take_damage(amount : float) -> void:
	hp -= amount


# STAMINA ----------------------------------------------------------------------
func set_stamina(value) -> void:
	if unlimited_stamina:
		return
	value = clamp(value, 0, max_stamina)
	stamina = value
	stamina_changed.emit(get_stamina_percent())
	if stamina <= 0:
		stamina_depleted.emit()

func get_stamina_percent() -> float:
	return stamina /float(max_stamina)
