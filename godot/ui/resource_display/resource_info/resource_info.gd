class_name ResourceInfo
extends PanelContainer

@onready var name_label = %NameLabel
@onready var amount_label = %AmountLabel
@onready var texture = %IconTexture
@onready var change_display = %ChangeDisplay

var resource_name : String = "" : set = set_resource_name
var resource_amount : int = 0 : set = set_resource_amount
var icon_texture_frames : Array[Texture] = [] : set = set_icon_texture_frames

var bounce_tween : Tween = null


func set_resource_name(value : String) -> void:
	resource_name = value
	%NameLabel.text = resource_name

func set_resource_amount(value : int) -> void:
	var change_amount = value - resource_amount
	if change_amount:
		change_display.accumulate(change_amount)
	resource_amount = value
	%AmountLabel.text = str(resource_amount)
	bounce_element(%AmountLabel)

func set_icon_texture_frames(value : Array[Texture]) -> void:
	icon_texture_frames = value
	var animated_texture : AnimatedTexture = %IconTexture.texture
	var frame_count = icon_texture_frames.size()
	animated_texture.frames = frame_count
	for i in frame_count:
		animated_texture.set_frame_texture(i, icon_texture_frames[i])

func bounce_element(element : Control):
	element.position.y = 0
	if bounce_tween: bounce_tween.kill()
	bounce_tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	bounce_tween.tween_property(element, "position:y", element.position.y - 3, 0.1)
	bounce_tween.set_trans(Tween.TRANS_BOUNCE)
	bounce_tween.tween_property(element, "position:y", 0, 0.4)
