@tool

extends PanelContainer

@export var action : String = "" : set = set_action
@export_range(0, 99, 1, "or_greater") var cost : int = 0 : set = set_cost
@export var linked_area : InteractionArea

@onready var action_label = %ActionLabel
@onready var cost_label = %CostLabel
@onready var cost_section = %CostSection
@onready var flash_color = %FlashColor
@onready var disable_overlay = %DisableOverlay
@onready var fx_container = %FxContainer
@onready var original_position = global_position

var flash_tween : Tween
var disabled := false : set = set_disabled


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	fx_container.show()
	flash_color.modulate.a = 0.0
	linked_area.interacted.connect(_on_linked_area_interacted)

func flash() -> void:
	flash_color.modulate.a = 1.0
	if flash_tween:
		flash_tween.kill()
	flash_tween = create_tween()
	flash_tween.tween_property(flash_color, "modulate:a", 0.0, 0.3)

#func _process(delta: float) -> void:
	#if not Engine.is_editor_hint():
		#keep_onscreen()

# FIXME: not respecting camera movement
#func keep_onscreen() -> void:
	#var viewport_rect = get_viewport().get_visible_rect()
	#var viewport_origin = viewport_rect.position
	#var viewport_end = viewport_rect.end
	#var max_position = viewport_end - size
	#global_position.x = clamp(original_position.x, viewport_origin.x, max_position.x)
	#global_position.y = clamp(original_position.y, viewport_origin.y, max_position.y)


# SETTERS ----------------------------------------------------------------------
func set_action(value : String):
	action = value
	%ActionLabel.text = action
	size.x = 0
	position.x = -size.x / 2.0

func set_cost(value : int):
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
