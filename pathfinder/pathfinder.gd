class_name Pathfinder

const grounded_costs : Dictionary[RoomPattern.TileType, float] = {
	RoomPattern.TileType.FLOOR: 1.0,
	RoomPattern.TileType.GRASS: 1.0,
	RoomPattern.TileType.WATER: 4.0,
	RoomPattern.TileType.PEDESTAL: 1.0
}

const aquatic_costs : Dictionary[RoomPattern.TileType, float] = {
	RoomPattern.TileType.WATER: 4.0
}

const flying_costs : Dictionary[RoomPattern.TileType, float] = {
	RoomPattern.TileType.FLOOR: 1.0,
	RoomPattern.TileType.GRASS: 1.0,
	RoomPattern.TileType.WATER: 1.0,
	RoomPattern.TileType.PEDESTAL: 1.0
}

var astar := CustomAstar.new()
func _init() -> void:
	astar.region = Rect2i(0, 0, Globals.floor_map.width, Globals.floor_map.height)
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar.update()

static func get_cost_dict(traversability: Char.Traversal):
	match traversability:
		Char.Traversal.GROUNDED:
			return grounded_costs
		Char.Traversal.AQUATIC:
			return aquatic_costs
		Char.Traversal.FLYING:
			return flying_costs
		_:
			return {}

func find_path(traversability: Char.Traversal, from: Vector2i, to: Vector2i, char_is_impassable: bool = false) -> Array[Vector2i]:
	match traversability:
		Char.Traversal.GROUNDED:
			astar.set_cost_dict(grounded_costs)
		Char.Traversal.AQUATIC:
			astar.set_cost_dict(aquatic_costs)
		Char.Traversal.FLYING:
			astar.set_cost_dict(flying_costs)
		_:
			astar.set_cost_dict({})
	if char_is_impassable:
		astar.set_char_cost(INF)
	else:
		astar.set_char_cost(4.0)
	var path := astar.get_id_path(from, to)
	return path

static func chebychev_dist(v1: Vector2i, v2: Vector2i) -> int:
	return max(abs(v1.x - v2.x), abs(v1.y - v2.y))
