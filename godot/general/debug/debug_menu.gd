extends CanvasLayer


@onready var game_speed_button = %GameSpeedButton


func _ready() -> void:
	game_speed_button.toggled.connect(_on_game_speed_button_toggled)

func _on_game_speed_button_toggled(toggled : bool) -> void:
	if toggled:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0
