extends TextureButton

@onready var original_color = modulate


func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_button_down() -> void:
	modulate = original_color.darkened(0.5)

func _on_button_up() -> void:
	modulate = original_color
