extends CanvasLayer

@export var test_joystick : bool = false

@onready var joystick_control = %JoystickControl

var touch_tags = [
	"web_android",
	"web_ios",
	"android",
	"ios"
]


func _ready() -> void:
	if test_joystick and OS.is_debug_build():
		touch_tags.append(OS.get_name().to_lower())
	joystick_control.visible = platform_uses_touch()


# CHECKS -----------------------------------------------------------------------
func platform_uses_touch() -> bool:
	for tag in touch_tags:
		if OS.has_feature(tag):
			return true
	return false
