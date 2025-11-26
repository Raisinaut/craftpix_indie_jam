class_name SelectionButton
extends PanelContainer

signal focus_changed(state : bool)
signal selected

@onready var disable_overlay = %DisableOverlay
@onready var overlay_text = %OverlayText
@onready var flash_color = %FlashColor
@onready var focus_color = %FocusColor

var disabled := false : set = set_disabled
var focused := false : set = set_focused
var hovered := false
var flash_tween : Tween

enum FUNCTIONS {
	PLACE,
	ERASE
}

@export var function : FUNCTIONS


func _ready() -> void:
	# Setup signals
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	overlay_text.hide()
	flash_color.hide()

func _input(event: InputEvent) -> void:
	if disabled or not focused:
		return
	if Input.is_action_just_pressed("select"):
		selected.emit()
		flash()


# EFFECTS ----------------------------------------------------------------------
func flash():
	flash_color.show()
	flash_color.modulate.a = 1.0
	if flash_tween: flash_tween.kill()
	flash_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	flash_tween.tween_property(flash_color, "modulate:a", 0, 0.3)


# SIGNALS ----------------------------------------------------------------------
func _on_mouse_entered() -> void:
	grab_focus()
	hovered = true

func _on_mouse_exited() -> void:
	release_focus()
	hovered = false

func _on_focus_entered() -> void:
	#overlay_text.show()
	focused = true

func _on_focus_exited() -> void:
	overlay_text.hide()
	focused = false


# SETTERS ----------------------------------------------------------------------
func set_disabled(state : bool) -> void:
	disabled = state
	disable_overlay.visible = disabled
	if hovered:
		# re-emit focus state to update related data 
		# for nodes that also check the disabled state
		focus_changed.emit(focused)

func set_focused(state : bool) -> void:
	focused = state
	focus_changed.emit(focused)
	focus_color.visible = focused
