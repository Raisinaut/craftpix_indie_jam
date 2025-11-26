extends TextureRect

var disabled : bool = false : set = set_disabled
var stiffness : float = 0.4 # perceived resistance to moving the stick
var deadzone : float = 0.5 # the minimum stick movement
var border : float = 0 # pixels

var fade_tween : Tween
var stick_tween : Tween

# Nodes
@onready var ring = self
@onready var stick_pivot = $StickPivot
@onready var stick = $StickPivot/Stick

# Measurements
@onready var ring_radius : float = ring.size.x / 2.0
@onready var stick_radius : float = stick.texture.get_size().x * stick.scale.x / 2.0
@onready var max_stick_distance : float = ring_radius - stick_radius - border


func _ready() -> void:
	disabled = true
	stick_pivot.position = get_center_offset()

func set_disabled(state):
	disabled = state
	if disabled:
		fade(0.0, 0.1)
		reset_stick(0.1)
		feed_joystick_input(Vector2.ZERO)
	else:
		fade(1.0, 0.0)

func _process(_delta):
	if not disabled:
		feed_joystick_input(get_tilt_vector())

func engage_at_position(pos : Vector2) -> void:
	disabled = false
	jump_to_position(pos)
	move_stick(pos)

func jump_to_position(pos : Vector2) -> void:
	global_position = pos - get_center_offset()

func move_stick(to_pos : Vector2) -> void:
	if stick_tween: stick_tween.kill()
	var displacement = to_pos - stick_pivot.global_position
	displacement = displacement * (1.0 - stiffness)
	var offset = displacement.limit_length(max_stick_distance)
	stick.position = offset

func reset_stick(duration : float):
	if stick_tween: stick_tween.kill()
	stick_tween = create_tween()
	stick_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	stick_tween.tween_property(stick, "position", Vector2.ZERO, duration)

# Emulate a joystick by providing inputs to Godot
func feed_joystick_input(input_vector : Vector2):
	var j_x = InputEventJoypadMotion.new()
	var j_y = InputEventJoypadMotion.new()
	j_x.set_axis(JOY_AXIS_LEFT_X)
	j_y.set_axis(JOY_AXIS_LEFT_Y)
	j_x.set_axis_value(input_vector.x)
	j_y.set_axis_value(input_vector.y)
	Input.parse_input_event(j_x)
	Input.parse_input_event(j_y)

# Returns a percentage of to stick tilt
# length ranges 0-1, depending on distance from ring center
func get_tilt_vector():
	var stick_distance = stick.position.distance_to(Vector2.ZERO)
	var tilt_vector = Vector2.ZERO.direction_to(stick.position)
	var tilt_percent = remap(stick_distance, 0, max_stick_distance, 0, 1)
	if tilt_percent < deadzone:
		tilt_vector = Vector2.ZERO
	return tilt_vector * tilt_percent

func get_center_offset() -> Vector2:
	return ring.size / 2.0

func fade(new_alpha : float, duration : float) -> void:
	if fade_tween: fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	fade_tween.tween_property(self, "modulate:a", new_alpha, duration)
