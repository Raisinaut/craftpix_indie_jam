extends Control

@onready var joystick = %Joystick
@onready var screen_press_areas = $ScreenPressAreas
@onready var valid_areas : Array = [%LeftSide, %RightSide]

var allow_input : bool = false


func _process(delta: float) -> void:
	# Set areas' visibilities to be inverse to the joystick's
	screen_press_areas.modulate.a = 1.0 - joystick.modulate.a

func _input(event):
	# Set joystick disabled state
	if event is InputEventScreenTouch:
		if event.pressed:
			if position_is_valid(event.position):
				joystick.engage_at_position(event.position)
		else:
			joystick.disabled = true
	# Set joystick movement
	if event is InputEventScreenDrag:
		if not joystick.disabled:
			joystick.move_stick(event.position)


# CHECKS -----------------------------------------------------------------------
func position_is_valid(pos : Vector2) -> bool:
	var valid := false
	for area : Control in valid_areas:
		if area.get_rect().has_point(pos):
			valid = true
			break
	return valid
