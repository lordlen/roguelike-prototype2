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
	var path := astar.get_id_path(from, to, true)
	# check if path has any impassable
	for cell in path.slice(0, len(path) - 1):
		var tile := Globals.floor_map.get_tile(cell)
		if tile.get_pf_cost(traversability) == INF:
			return []
	return path

func get_straight_path(from: Vector2i, to: Vector2i, traversibility: Char.Traversal) -> Array[Vector2i]:
	var char_dict := ActorManager.get_chars_dict()
	var path := Geometry2D.bresenham_line(from, to)
	
	# loop, removing the start and end points
	var size := 1
	for pos in path.slice(1, len(path)):
		var tile := Globals.floor_map.get_tile(pos)
		var is_traversible := tile.get_pf_cost(traversibility) != INF
		if !is_traversible:
			return path.slice(0, size)
		size += 1
		if char_dict.has(pos):
			return path.slice(0, size)
	return path

func get_straight_path_actor(from: Vector2i, to: Vector2i, traversibility: Char.Traversal) -> Array[Vector2i]:
	var char_dict := ActorManager.get_chars_dict()
	var path := Geometry2D.bresenham_line(from, to)
	
	# loop, removing the start and end points
	var size := 1
	for pos in path.slice(1, len(path)):
		var tile := Globals.floor_map.get_tile(pos)
		var is_traversible := tile.get_pf_cost(traversibility) != INF
		if !is_traversible or char_dict.has(pos):
			return path.slice(0, size)
		size += 1
	return path

static func chebychev_dist(v1: Vector2i, v2: Vector2i) -> int:
	return max(abs(v1.x - v2.x), abs(v1.y - v2.y))
