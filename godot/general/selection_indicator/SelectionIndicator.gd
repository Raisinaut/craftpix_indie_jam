class_name SelectionIndicator
extends Node2D

@onready var animator = $AnimationPlayer

func update_corners(reference) -> int:
	if not reference is Control:
		push_error("Selection Indicator requires a Control node, try a ReferenceRectangle")
		return -1
	
	var top_left = Vector2.ZERO
	var bottom_right = reference.size
	$TopLeft.position = top_left
	$TopRight.position = Vector2(bottom_right.x, top_left.y)
	$BottomRight.position = bottom_right
	$BottomLeft.position = Vector2(top_left.x, bottom_right.y)
	
	if global_position == reference.global_position:
		return 1 # Only corners adapted
	
	global_position = reference.global_position
	
	# Specific to non-control nodes (i.e. not menu options)
	var ref_parent = reference.get_parent()
	if ref_parent is Node2D:
		rotation = ref_parent.rotation
		# compensate for scale-flipped entities
		if ref_parent.scale.x == -1:
			global_position.x -= reference.rect_size.x
	
	return 0
