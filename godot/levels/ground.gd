extends TileMapLayer

@export var enemy_path : Path2D

var track_tiles : Array[Vector2i]


func update_track_tiles() -> void:
	track_tiles.clear()
	var sample_offset : float = 0.0
	var change_interval : float = 5.0
	var max_offset = enemy_path.curve.get_baked_length()
	while sample_offset <= max_offset:
		var curve_pos = enemy_path.curve.sample_baked(sample_offset)
		var map_pos = local_to_map(curve_pos)
		if not track_tiles.has(map_pos):
			track_tiles.append(map_pos)
		sample_offset += change_interval
	set_cells_terrain_path(track_tiles, 0, 1)
	
