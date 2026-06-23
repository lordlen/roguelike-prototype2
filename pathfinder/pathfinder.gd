class_name Pathfinder

var astar := CustomAstar.new()
func _init() -> void:
	astar.region = Rect2i(0, 0, Globals.floor_map.width, Globals.floor_map.height)
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar.update()

func find_path(traversability: Char.Traversal, from: Vector2i, to: Vector2i, char_is_impassable: bool = false) -> Array[Vector2i]:
	astar.set_traversal(traversability)
	if char_is_impassable:
		astar.set_char_cost(INF)
	else:
		astar.set_char_cost(4.0)
	var path := astar.get_id_path(from, to)
	return path

static func chebychev_dist(v1: Vector2i, v2: Vector2i) -> int:
	return max(abs(v1.x - v2.x), abs(v1.y - v2.y))
