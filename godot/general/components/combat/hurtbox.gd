# Allows its owner to detect hits and take damage
class_name HurtBox
extends Area2D

signal invincibility_started
signal invincibility_ended

@export_category("Connections")
@export var stats : Stats

@export_category("Invincibility")
## Prevents hit registration for a set duration.
@export var automatic_invincibility := true
## The duration of invincibility after registering a hit
@export_range(0.1, 3, 0.1) var invincibilty_duration : float = 2.0 # seconds

@export_category("Misc")
@export var friendly_groups : Array[String] = []

var last_registered_hit := {
	"damage" : 0,
	"direction" : 0,
}
var invincible := false : set = set_invincible
var i_timer : SceneTreeTimer = null



func _init() -> void:
	# The hurtbox should detect hits but not deal them. 
	# This variable does that.
	monitorable = false
	setup_collision()


func setup_collision():
	collision_layer = int(pow(2, 8-1))
	collision_mask = int(pow(2, 7-1))


func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	connect("invincibility_started", self._on_invincibility_started)
	connect("invincibility_ended", self._on_invincibility_ended)


func register_hit(hitbox : HitBox):
	if hitbox.owner == self:
		return
	
	if is_friendly(hitbox):
		return
	
	if !stats:
		return
	
	if stats.has_method("take_damage"):
		stats.take_damage(hitbox.damage)
		last_registered_hit.damage = hitbox.damage
	
	#if owner.has_method("take_knockback"):
		#var knockback_vec = -global_position.direction_to(hitbox.global_position)
		#if hitbox.get("knockback_direction") != null:
			#knockback_vec = hitbox.knockback_direction
		#owner.take_knockback(hitbox.knockback, knockback_vec)
		#last_registered_hit.direction = knockback_vec
	
	# double check this export variable if experiencing issues
	if automatic_invincibility:
		start_invincibility(invincibilty_duration)
	
	hitbox.detected.emit(self)


func is_friendly(hitbox : HitBox):
	for g in friendly_groups:
		if hitbox.owner.is_in_group(g):
			return true
	return false



# INVINCIBILITY ---------------------------------------------------------------#

func set_invincible(state):
	invincible = state
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration : float = invincibilty_duration):
	self.set_invincible(true)
	# start invincibility timer
	i_timer = get_tree().create_timer(duration, false)
	i_timer.connect("timeout", self.set_invincible.bind(false))



# SIGNALS ---------------------------------------------------------------------#

func _on_area_entered(hitbox):
	register_hit(hitbox)


func _on_invincibility_started():
	set_deferred("monitoring", false)


func _on_invincibility_ended():
	set_deferred("monitoring", true)
