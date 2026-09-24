class_name World
extends RefCounted

static func grid_to_world(grid_position: Vector2i) -> Vector2:
	var offset := Vector2i(Consts.TILE_SIZE / 2, Consts.TILE_SIZE / 2)
	return grid_position * Consts.TILE_SIZE + offset
