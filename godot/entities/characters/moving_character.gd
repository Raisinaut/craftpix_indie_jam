class_name MovingCharacter
extends CharacterBody2D

const BASE_SPEED = 80

enum STATES {
	MOVE,
	ATTACK,
	HURT,
	DEATH
}

var state := STATES.MOVE : set = set_state
var move_direction := Vector2.ZERO
var last_velocity := Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var sprite_animator = $SpriteAnimator


func _ready() -> void:
	state = STATES.MOVE

func _process(delta: float) -> void:
	match(state):
		STATES.MOVE:
			walk(delta)
			var anim_name = "walk_" + get_vector_direction(velocity)
			if velocity == Vector2.ZERO:
				anim_name = "idle_" + get_vector_direction(last_velocity)
			sprite_animator.play(anim_name)
			update_sprite_flip()


# STATE PROCESS LOGIC ----------------------------------------------------------
func walk(_delta : float):
	if move_direction:
		velocity = BASE_SPEED * move_direction
		last_velocity = velocity
	else:
		velocity = Vector2.ZERO
	move_and_slide()


# STATE CHANGE LOGIC -----------------------------------------------------------
func set_state(value : STATES):
	state = value
	match(state):
		STATES.MOVE:
			pass


# UPDATE FUNCTIONS -------------------------------------------------------------
func update_sprite_flip() -> void:
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false


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
