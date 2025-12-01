# Original code version found online: 
# https://www.reddit.com/r/godot/comments/10ql0ch/
# godot_4_does_tilemap_have_a_way_to_retrieve_the/

extends TileMapLayer
class_name SceneTileMapLayer

signal child_registered(child)

var scene_coords: Dictionary[Vector2i, Node] = {}

func _enter_tree():
	child_entered_tree.connect(_register_child)
	child_exiting_tree.connect(_unregister_child)

func _register_child(child):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta("tile_coords", coords)
	child_registered.emit(child)

func _unregister_child(child):
	scene_coords.erase(child.get_meta("tile_coords"))

func get_cell_scene(coords: Vector2i) -> Node:
	return scene_coords.get(coords, null)
