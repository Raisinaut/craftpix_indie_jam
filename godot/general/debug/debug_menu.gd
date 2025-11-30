extends CanvasLayer


@onready var game_speed_button = %GameSpeedButton
@onready var rich_button = %RichButton

@export var enable_outside_debug : bool = false

var enabled : bool = false : set = set_enabled


func _ready() -> void:
	game_speed_button.toggled.connect(_on_game_speed_button_toggled)
	rich_button.toggled.connect(_on_rich_button_toggled)
	#if enable_outside_debug or OS.is_debug_build():
		#show()

func _on_game_speed_button_toggled(toggled : bool) -> void:
	if toggled:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0

func _on_rich_button_toggled(toggled : bool) -> void:
	GameManager.infinite_money = toggled

func set_enabled(state : bool) -> void:
	enabled = state
	visible = enabled
	if not enabled:
		disengage_buttons()

func disengage_buttons() -> void:
	game_speed_button.button_pressed = false
	rich_button.button_pressed = false
