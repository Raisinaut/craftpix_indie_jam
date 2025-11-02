extends CharacterBody2D

const BASE_SPEED = 80

enum STATES {
	IDLE,
	WALK,
	ATTACK,
	HURT,
	DEATH
}

var state := STATES.IDLE : set = set_state
var input_direction := Vector2.ZERO
var last_velocity := Vector2.ZERO

@onready var sprite = $Sprite2D


func _ready() -> void:
	state = STATES.IDLE

func _process(delta: float) -> void:
	sprite.play()
	update_input_direction()
	match(state):
		STATES.IDLE:
			idle()
		STATES.WALK:
			walk(delta)
			var anim_name = "walk_" + get_vector_as_string(velocity)
			sprite.animation = anim_name
			update_sprite_flip()
			if velocity == Vector2.ZERO:
				set_state(STATES.IDLE)


# STATE PROCESS LOGIC ----------------------------------------------------------
func idle():
	if input_direction:
		set_state(STATES.WALK)

func walk(_delta : float):
	if input_direction:
		velocity = BASE_SPEED * input_direction
		last_velocity = velocity
	else:
		velocity = Vector2.ZERO
	move_and_slide()


# STATE CHANGE LOGIC -----------------------------------------------------------
func set_state(value : STATES):
	state = value
	match(state):
		STATES.IDLE:
			sprite.animation = "idle_" + get_vector_as_string(last_velocity)
		STATES.WALK:
			pass


# UPDATE FUNCTIONS -------------------------------------------------------------
func update_input_direction() -> void:
	input_direction = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down")

func update_sprite_flip() -> void:
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false


func get_vector_as_string(vector : Vector2) -> String:
	var direction : String = ""
	if abs(vector.x) > abs(vector.y):
		direction = "side"
	else:
		if vector.y >= 0:
			direction = "down"
		else:
			direction = "up"
	return direction
