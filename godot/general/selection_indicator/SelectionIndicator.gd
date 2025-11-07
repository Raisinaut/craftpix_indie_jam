@tool
extends Node2D

@onready var animator = $AnimationPlayer

@export_range(0.0, 4.0, 1.0) var pulse_amount = 1.0
@export var corner_texture : Texture : set = set_corner_texture

func _ready():
	if not Engine.is_editor_hint():
		setup_animation()


func update_corners(reference) -> int:
	if not reference is Control:
		push_error("Selection Indicator requires a Control node, try a ReferenceRectangle")
		return -1
	
	var top_left = Vector2.ZERO
	var bottom_right = reference.rect_size
	$TopLeft.position = top_left
	$TopRight.position = Vector2(bottom_right.x, top_left.y)
	$BottomRight.position = bottom_right
	$BottomLeft.position = Vector2(top_left.x, bottom_right.y)
	
	if global_position == reference.rect_global_position:
		return 1 # Only corners adapted
	
	global_position = reference.rect_global_position
	
	# Specific to non-control nodes (i.e. not menu options)
	var ref_parent = reference.get_parent()
	if ref_parent is Node2D:
		rotation = ref_parent.rotation
		# compensate for scale-flipped entities
		if ref_parent.scale.x == -1:
			global_position.x -= reference.rect_size.x
			
	return 0

func set_corner_texture(value : Texture) -> void:
	corner_texture = value
	for i in get_children():
		if i is Sprite2D:
			i.texture = corner_texture

# Overwrites Pulse animation's offset key values
#func setup_animation():
	#var animation = animator.get_animation("PULSE")
	#for i in animation.get_track_count():
		#animation.track_set_key_value(i, 1, [-pulse_amount, -0.25, 0, 0.25, 0])
	#animator.add_animation("PULSE", animation)
	#animator.play("PULSE")
