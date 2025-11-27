class_name Ballista
extends Node2D

@onready var sprite = $Sprite
@onready var interaction_area = $InteractionArea
@onready var interact_display = $InteractCost
@onready var emitter = $Emitter

var initialized : bool = false
var interval : float = 1.5
var direction := Vector2.RIGHT : set = set_direction


func _ready() -> void:
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	interaction_area.interacted.connect(_on_interaction_area_interacted)
	interact_display.hide()
	await delay()
	initialized = true
	activate()

func activate() -> void:
	sprite.play(get_directional_animation_name("fire"))
	emitter.emit()

func reset() -> void:
	sprite.play(get_directional_animation_name("default"))
	start_interval()

func _process(delta: float) -> void:
	if initialized:
		interact_display.visible = interaction_area.can_interact()

func get_directional_animation_name(anim_name : String) -> String:
	return anim_name + "_" + get_vector_as_string(direction)

func get_vector_as_string(vector : Vector2) -> String:
	var d : String = ""
	if abs(vector.x) > abs(vector.y):
		if vector.x >= 0:
			d = "right"
		else:
			d = "left"
	else:
		if vector.y >= 0:
			d = "down"
		else:
			d = "up"
	return d


# SETTERS ----------------------------------------------------------------------
func set_direction(value : Vector2) -> void:
	direction = value


# TIMERS -----------------------------------------------------------------------
func start_interval():
	get_tree().create_timer(interval).timeout.connect(_on_interval_timeout)

func delay():
	await get_tree().create_timer(0.05).timeout


# SIGNALS ----------------------------------------------------------------------
func _on_interval_timeout() -> void:
	activate()

func _on_interaction_area_interacted() -> void:
	direction = direction.rotated(-PI/2)
	emitter.emission_direction = direction
	if sprite_is_firing():
		var last_frame = sprite.frame
		sprite.play(get_directional_animation_name("fire"))
		sprite.frame = last_frame
		
	else:
		sprite.play(get_directional_animation_name("default"))

func _on_sprite_animation_finished() -> void:
	if sprite_is_firing():
		reset()


# CHECKS -----------------------------------------------------------------------
func sprite_is_firing() -> bool:
	return sprite.animation.contains("fire")
