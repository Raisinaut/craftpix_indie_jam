@tool
class_name InteractPrompt
extends PanelContainer

## Useful for representing the interaction state of the object.
@export var action_icons : Array[Texture] = [] : set = set_action_icons
@export var action : String = "" : set = set_action
@export_range(0, 99, 1, "or_greater") var cost : int = 0 : set = set_cost
@export var linked_area : InteractionArea

@onready var action_label = %ActionLabel
@onready var action_icon = %ActionIcon
@onready var cost_label = %CostLabel
@onready var cost_section = %CostSection
@onready var flash_color = %FlashColor
@onready var disable_overlay = %DisableOverlay
@onready var fx_container = %FxContainer
@onready var touch_button = $TouchScreenButton

@onready var original_position = global_position

var flash_tween : Tween
var disabled := false : set = set_disabled


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	fx_container.show()
	flash_color.modulate.a = 0.0
	if linked_area:
		linked_area.interacted.connect(_on_linked_area_interacted)
	sync_touch_button_size()
	touch_button.pressed.connect(_on_touch_button_pressed)

func flash() -> void:
	flash_color.modulate.a = 0.5
	if flash_tween: flash_tween.kill()
	flash_tween = create_tween()
	flash_tween.tween_property(flash_color, "modulate:a", 0.0, 0.3)

func sync_touch_button_size() -> void:
	touch_button.shape = RectangleShape2D.new()
	touch_button.shape.size = size
	touch_button.position = size / 2.0

func update_action_icon(texture_idx : int) -> void:
	if texture_idx < 0 or action_icons.is_empty():
		action_icon.texture = null
	elif texture_idx >= 0:
		action_icon.texture = action_icons[texture_idx]

func recenter_horizontal() -> void:
	size.x = 0
	position.x = -size.x / 2.0

# SETTERS ----------------------------------------------------------------------
func set_action(value : String) -> void:
	action = value
	%ActionLabel.text = action
	recenter_horizontal()

func set_action_icons(arr : Array[Texture]) -> void:
	action_icons = arr
	if not %ActionIcon.is_node_ready():
		await %ActionIcon.ready
	if not action_icons.is_empty():
		%ActionIcon.texture = action_icons[0]
	else:
		%ActionIcon.texture = null
	recenter_horizontal()

func set_cost(value : int) -> void:
	cost = value
	%CostSection.visible = cost > 0
	#size.y = 0
	%CostLabel.text = str(cost)

func set_disabled(state : bool) -> void:
	disabled = state
	disable_overlay.visible = disabled


# SIGNALS ----------------------------------------------------------------------
func _on_linked_area_interacted() -> void:
	flash()

func _on_touch_button_pressed() -> void:
	if linked_area:
		linked_area.interacted.emit()
	else:
		push_error("Could not interact via touch_button without a linked area")
