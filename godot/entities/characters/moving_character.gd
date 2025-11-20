class_name MovingCharacter
extends CharacterBody2D

signal attacked
signal died

enum STATES {
	MOVE,
	ATTACK,
	HURT,
	DEATH,
}

var state := STATES.MOVE : set = set_state
var move_direction := Vector2.ZERO
var last_velocity := Vector2.ZERO
var actual_velocity : Vector2
var last_position : Vector2


@export_range(10, 100, 1.0, "or_greater") var base_speed : float = 80
@export var attack_rate : float = 1.0

@onready var sprite = $Sprite2D
@onready var sprite_animator = $SpriteAnimator
@onready var stats = $Stats
@onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	state = STATES.MOVE
	stats.hp_depleted.connect(_on_hp_depleted)
	stats.hp_lost.connect(_on_hp_lost)

func _process(_delta: float) -> void:
	match(state):
		STATES.MOVE:
			move()
		STATES.ATTACK:
			pass
	actual_velocity = global_position - last_position
	last_position = global_position


# STATE LOGIC ----------------------------------------------------------
func move():
	if move_direction:
		velocity = base_speed * move_direction
		last_velocity = velocity
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	var anim_name = "walk_" + get_vector_direction(last_velocity)
	if move_direction != Vector2.ZERO:
		sync_sprite_flip(velocity)
	else:
		if velocity == Vector2.ZERO:
			anim_name = "idle_" + get_vector_direction(last_velocity)
	sprite_animator.play(anim_name)

func die() -> void:
	died.emit()
	play_animation_in_facing_direction("death", last_velocity)
	await sprite_animator.animation_finished
	queue_free()


# STATE CHANGE LOGIC -----------------------------------------------------------
func set_state(value : STATES):
	sprite_animator.speed_scale = 1.0
	state = value
	match(state):
		STATES.ATTACK:
			sprite_animator.speed_scale = attack_rate
			play_animation_in_facing_direction("attack", last_velocity)
		STATES.DEATH:
			die()
		STATES.HURT:
			sprite.flash(0.25)
			play_animation_in_facing_direction("hurt", actual_velocity)
			await sprite_animator.animation_finished
			set_state(STATES.MOVE)


# SIGNALS ----------------------------------------------------------------------
func _on_hp_depleted() -> void:
	set_state(STATES.DEATH)

func _on_hp_lost() -> void:
	set_state(STATES.HURT)

# ANIMATION METHODS ------------------------------------------------------------
func attack_keyframe_rached():
	attacked.emit()
	stats.stamina -= 1


# UPDATE FUNCTIONS -------------------------------------------------------------
func sync_sprite_flip(vector : Vector2) -> void:
	if vector.x > 0:
		sprite.flip_h = true
	elif vector.x < 0:
		sprite.flip_h = false


func play_animation_in_facing_direction(anim_prefix : String, vector : Vector2):
	var dir : String = get_vector_direction(vector)
	sprite_animator.play(anim_prefix + "_" + dir)

## Returns a string matching the vector's direction. [br]
## Combine_horizontal merges "left" and "right" into "side"
func get_vector_direction(vector : Vector2, combine_horizontal := true) -> String:
	var direction : String = ""
	if abs(vector.x) > abs(vector.y):
		if combine_horizontal:
			direction = "side"
		
		elif vector.x >= 0:
			direction = "right"
		else:
			direction = "left"
	else:
		if vector.y >= 0:
			direction = "down"
		else:
			direction = "up"
	return direction


# CHECKS -----------------------------------------------------------------------
func is_attacking() -> bool:
	var current_animation : String = sprite_animator.current_animation
	return current_animation.begins_with("attack")

func is_dead() -> bool:
	return state == STATES.DEATH
