class_name TrapButton
extends PanelContainer

signal focus_changed(state : bool)
signal selected

@export var data : TrapData = null : set = set_data

@onready var trap_icon = %TrapIcon
@onready var cost_label = %CostLabel
@onready var disable_overlay = %DisableOverlay
@onready var overlay_text = %OverlayText
@onready var flash_color = %FlashColor
@onready var focus_color = %FocusColor

var disabled := false : set = set_disabled
var focused := false : set = set_focused
var flash_tween : Tween

func _ready() -> void:
	# Setup signals
	GameManager.currency_modified.connect(_on_game_manager_currency_modified)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(release_focus)
	
	overlay_text.hide()
	flash_color.hide()

func _input(event: InputEvent) -> void:
	if disabled or not focused:
		return
	if Input.is_action_just_pressed("select"):
		selected.emit()
		flash()

func match_data(d = data) -> void:
	trap_icon.texture = data.icon
	cost_label.text = str(data.base_cost)
	update_disabled()

func update_disabled():
	disabled = not GameManager.can_afford(data.base_cost)
	if disabled:
		focus_changed.emit(focused)
	#if disabled:
		#focus_mode = Control.FOCUS_NONE
	#else:
		#focus_mode = Control.FOCUS_ALL


# EFFECTS ----------------------------------------------------------------------
func flash():
	flash_color.show()
	flash_color.modulate.a = 1.0
	if flash_tween: flash_tween.kill()
	flash_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	flash_tween.tween_property(flash_color, "modulate:a", 0, 0.3)


# SIGNALS ----------------------------------------------------------------------
func _on_focus_entered() -> void:
	#overlay_text.show()
	focused = true

func _on_focus_exited() -> void:
	overlay_text.hide()
	focused = false

func _on_game_manager_currency_modified(_value : int) -> void:
	update_disabled()
	if not disabled:
		# reemit focus state to update related data 
		# for nodes that rely on those signals
		focus_changed.emit(focused)


# SETTERS ----------------------------------------------------------------------
func set_disabled(state : bool) -> void:
	disabled = state
	disable_overlay.visible = disabled

func set_focused(state : bool) -> void:
	focused = state
	focus_changed.emit(focused)
	focus_color.visible = focused

func set_data(d) -> void:
	data = d
	match_data()
