extends CanvasLayer

# Options
@onready var game_speed_button = %GameSpeedButton
@onready var rich_button = %RichButton
@onready var meter_visiblity_button = %MeterVisibilityButton

@onready var menu_visibility_button = %MenuVisibilityButton
@onready var option_container = %OptionContainer

@export var enable_outside_debug : bool = false

var enabled : bool = false : set = set_enabled
var options_visible : bool = false : set = set_options_visible

func _ready() -> void:
	options_visible = false
	game_speed_button.toggled.connect(_on_game_speed_button_toggled)
	rich_button.toggled.connect(_on_rich_button_toggled)
	meter_visiblity_button.toggled.connect(_on_meter_visiblity_button_toggled)
	menu_visibility_button.toggled.connect(_on_menu_visibility_button_toggled)
	if not OS.is_debug_build() or enable_outside_debug:
		hide()

func revert_button_states() -> void:
	game_speed_button.button_pressed = false
	rich_button.button_pressed = false
	meter_visiblity_button.pressed = true

# SIGNALS ----------------------------------------------------------------------
func _on_game_speed_button_toggled(toggled : bool) -> void:
	if toggled:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0

func _on_menu_visibility_button_toggled(toggled : bool) -> void:
	options_visible = toggled

func _on_rich_button_toggled(toggled : bool) -> void:
	GameManager.infinite_money = toggled

func _on_meter_visiblity_button_toggled(toggled : bool) -> void:
	GameManager.hide_meters = not toggled


# SETTERS ----------------------------------------------------------------------
func set_enabled(state : bool) -> void:
	enabled = state
	visible = enabled
	if not enabled:
		revert_button_states()

func set_options_visible(state : bool) -> void:
	option_container.visible = state
