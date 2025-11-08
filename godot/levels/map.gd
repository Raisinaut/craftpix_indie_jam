class_name InteractableMap
extends Node2D

@onready var ground = $Ground
@onready var holes = $Holes
@onready var traps = $Traps
@onready var track = $EnemyTrack
@onready var traps_hover = $TrapsHover
@onready var highlight_box = $Ground/HighlightBox

var highlight_idx = Vector2i.ZERO
var selected_scene = -1


func _ready() -> void:
	# Change ground z-index to allow for more layered spritework
	ground.z_index = -10
	highlight_box.z_index = 1

func _process(delta: float) -> void:
	update_hover()
	update_highlight()

func update_hover():
	traps_hover.clear()
	var player_position = GameManager.player.global_position
	highlight_idx = traps_hover.local_to_map(player_position)
	var tile_idx = selected_scene + 1 #always add one when accessing tiles
	if is_idx_valid(tile_idx):
		traps_hover.set_cell(highlight_idx, 0, Vector2i(0, 0), tile_idx)

func update_highlight():
	highlight_box.visible = is_highlighting()
	if highlight_box.visible:
		var highlight_pos = traps_hover.map_to_local(highlight_idx)
		var highlight_color = Color.WHITE
		highlight_box.global_position = highlight_pos
		if not can_place():
			highlight_color = Color("e43b44")
			highlight_box.play("bad")
		else:
			highlight_box.play("good")
		highlight_box.modulate = highlight_color

func place_trap(cost : int):
	var tile_idx = selected_scene + 1
	if is_idx_valid(tile_idx):
		GameManager.currency -= cost
		traps.set_cell(highlight_idx, 0, Vector2i(0, 0), tile_idx)


# CHECKS -----------------------------------------------------------------------
func is_cell_valid(coords : Vector2i) -> bool:
	var usable_coords : Array = ground.get_used_cells()
	var used_coords : Array = traps.get_used_cells()
	var track_coords : Array = track.get_used_cells()
	for c in used_coords:
		usable_coords.erase(c)
	for c in track_coords:
		usable_coords.erase(c)
	return usable_coords.has(coords)

func is_idx_valid(idx : int) -> bool:
	var hover_tile_set : TileSet = traps.tile_set
	var scene_collection : TileSetScenesCollectionSource = hover_tile_set.get_source(0)
	return scene_collection.has_scene_tile_id(idx)

func is_highlighting() -> bool:
	return traps_hover.get_used_cells().size() > 0

func can_place() -> bool:
	return is_cell_valid(highlight_idx)
