class_name Floor

var width: int
var height: int
var used_cells: Dictionary[Vector2i, TileResource]
var astar: AStarGrid2D
var random_dijkstra_maps: Array[DijkstraMap] = []
func _init(width: int, height: int):
	self.width = width
	self.height = height
	used_cells = {}
	self.astar = AStarGrid2D.new()
	self.astar.region = Rect2i(0, 0, width, height)
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ALWAYS
	astar.update()
	
	for x in range(width):
		for y in range(height):
			var pos := Vector2i(x,y)
			astar.set_point_solid(pos)

func add_dijkstra_map(points: Array[Vector2i]):
	var dm := DijkstraMap.new(self)
	dm.set_traversal(Char.Traversal.GROUNDED)
	dm.set_targets(points)
	dm.set_chars(Globals.actors)
	random_dijkstra_maps.push_back(dm)

func initialize_all_dijkstra_maps():
	for dm in random_dijkstra_maps:
		dm.instantiate()

func pick_random_dijkstra_map() -> DijkstraMap:
	return random_dijkstra_maps.pick_random()

func append_back(used_cells: Array[Vector2i], cell_types: Array[TileResource]):
	if len(used_cells) != len(cell_types):
		print('mismatched lengths')
		return
	
	for i in range(len(used_cells)):
		var cell := used_cells[i]
		var type := cell_types[i]
		
		set_tile(cell, type)

func set_tile(cell: Vector2i, tile: TileResource):
	self.used_cells[cell] = tile
	if tile.grounded_cost != INF:
		astar.set_point_solid(cell, false)
	else:
		astar.set_point_solid(cell)

func update_tile(cell: Vector2i, type: TileResource):
	set_tile(cell, type)
	EventBus.floor_tile_updated.emit(cell, type)

func get_tile(v: Vector2i) -> TileResource:
	if v in used_cells:
		return used_cells[v]
	else:
		return load("res://floor_generator/tiles/wall.tres")

# cells are cells for a room
func is_no_point_overlap(cells: Array[Vector2i]) -> bool:
	# for each cell, we want to get adjacent tiles to prevent room merging
	var cell_checks : Dictionary[Vector2i, bool]= {}
	
	for c in cells:
		cell_checks[c] = true
		cell_checks[c + Vector2i.UP] = true
		cell_checks[c + Vector2i.DOWN] = true
		cell_checks[c + Vector2i.LEFT] = true
		cell_checks[c + Vector2i.RIGHT] = true
		cell_checks[c + Vector2i.UP + Vector2i.LEFT] = true
		cell_checks[c + Vector2i.UP + Vector2i.RIGHT] = true
		cell_checks[c + Vector2i.DOWN + Vector2i.LEFT] = true
		cell_checks[c + Vector2i.DOWN + Vector2i.RIGHT] = true
	
	# only tolerate 1 overlap
	var count := 0
	for c in cell_checks:
		if !is_within_bounds(c):
			return false
		if c in used_cells:
			count += 1
			if count > 3:
				return false
	return true

func is_within_used_cells(cells: Array[Vector2i]):
	# for each cell, we want to get adjacent tiles to prevent room merging
	var cell_checks : Dictionary[Vector2i, bool]= {}
	
	for c in cells:
		cell_checks[c] = true
		cell_checks[c + Vector2i.UP] = true
		cell_checks[c + Vector2i.DOWN] = true
		cell_checks[c + Vector2i.LEFT] = true
		cell_checks[c + Vector2i.RIGHT] = true
		cell_checks[c + Vector2i.UP + Vector2i.LEFT] = true
		cell_checks[c + Vector2i.UP + Vector2i.RIGHT] = true
		cell_checks[c + Vector2i.DOWN + Vector2i.LEFT] = true
		cell_checks[c + Vector2i.DOWN + Vector2i.RIGHT] = true
	
	for c in cell_checks:
		if !is_within_bounds(c):
			return false
		if c not in used_cells:
			return false
	return true
	
func is_within_bounds(v: Vector2i) -> bool:
	return 0 <= v.x and v.x < width and 0 <= v.y and v.y < height

func get_random_wall() -> Array[Vector2i]:
	# first pick a random used cell
	var random_point : Vector2i= used_cells.keys().pick_random()
	
	# pick a random direction
	var random_dir :Vector2i = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
	var curr_point := random_point + random_dir
	
	while is_within_bounds(curr_point) and curr_point in used_cells:
		curr_point = curr_point + random_dir
	
	return [curr_point, random_dir]

func has(v:Vector2i):
	return used_cells.has(v)
	
func get_all_tiles() -> Dictionary[Vector2i, TileResource]:
	return used_cells

func compute_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	return astar.get_id_path(from, to)

func get_type_positions(tile_types: Array[TileResource.Terrains]) -> Array[Vector2i]:
	var position_list : Array[Vector2i] = []
	for position in used_cells:
		if used_cells[position].terrain_id in tile_types:
			position_list.push_back(position)
	return position_list

func get_valid_adjacent(center: Vector2i) -> Array[Vector2i]:
	var ret : Array[Vector2i] = []
	for cell in DijkstraMap._get_adjacent_edges(center):
		if ActorManager.get_actor_in_position(cell) == null and\
		Globals.floor_map.get_tile(cell).get_pf_cost(Char.Traversal.GROUNDED) != INF:
			ret.push_back(cell)
	return ret
