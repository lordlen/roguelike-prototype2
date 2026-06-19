class_name FoV

var floor: Floor
var vision_set: Dictionary[Vector2i, bool]
var explored_set: Dictionary[Vector2i, bool]

func _init(floor: Floor, vision_set: Dictionary[Vector2i, bool], explored_set: Dictionary[Vector2i, bool]):
	self.floor = floor
	self.vision_set = vision_set
	self.explored_set = explored_set

func compute_fov(origin: Vector2i, depth: int):
	mark_visible(origin)
	
	for i in range(4):
		var quadrant := Quadrant.new(i, origin)

		var first_row := Row.new(1, -1, 1)
		scan_iterative(first_row, quadrant, depth)

func slope(tile: Vector2i):
	var row_depth := tile.x
	var col := tile.y
	return (2.0 * col - 1) / (2.0 * row_depth)

func is_symmetric(row: Row, tile: Vector2i):
	var row_depth := tile.x
	var col := tile.y
	return (col >= row.depth * row.start_slope
		and col <= row.depth * row.end_slope)

func is_wall(tile, quadrant: Quadrant) -> bool:
	if tile == null:
		return false
	
	var grid_pos := quadrant.transform(tile)
	return Tiles.TileDictionary[floor.get_tile(grid_pos)].is_opaque()

func is_floor(tile, quadrant: Quadrant):
	if tile == null:
		return false
	
	var grid_pos := quadrant.transform(tile)
	return !Tiles.TileDictionary[floor.get_tile(grid_pos)].is_opaque()


func reveal(tile: Vector2i, quadrant: Quadrant):
	var grid_pos := quadrant.transform(tile)
	mark_visible(grid_pos)

func mark_visible(grid_pos: Vector2i):
	vision_set[grid_pos] = true
	explored_set[grid_pos] = true

func is_within_bounds(tile, quadrant: Quadrant):
	if tile == null:
		return true
	var grid_pos := quadrant.transform(tile)
	return floor.is_within_bounds(grid_pos)

func scan_iterative(row: Row, quadrant: Quadrant, depth: int):
	var rows := [row]
	while rows:
		row = rows.pop_back()
		if row.depth > depth:
			continue
		var prev_tile = null
		for tile in row.tiles():
			if !is_within_bounds(tile, quadrant):
				continue
			if is_wall(tile, quadrant) or is_symmetric(row, tile):
				reveal(tile, quadrant)
			if is_wall(prev_tile, quadrant) and is_floor(tile, quadrant):
				row.start_slope = slope(tile)
			if is_floor(prev_tile, quadrant) and is_wall(tile, quadrant):
				var next_row = row.next()
				next_row.end_slope = slope(tile)
				rows.append(next_row)
			prev_tile = tile
		if is_floor(prev_tile, quadrant):
			rows.append(row.next())

func scan(row, quadrant: Quadrant):
	var prev_tile = null
	for tile in row.tiles():
		if !is_within_bounds(tile, quadrant):
			continue
		if is_wall(tile, quadrant) or is_symmetric(row, tile):
			reveal(tile, quadrant)
		if is_wall(prev_tile, quadrant) and is_floor(tile, quadrant):
			row.start_slope = slope(tile)
		if is_floor(prev_tile, quadrant) and is_wall(tile, quadrant):
			var next_row = row.next()
			next_row.end_slope = slope(tile)
			scan(next_row, quadrant)
		prev_tile = tile
	if is_floor(prev_tile, quadrant):
		scan(row.next(), quadrant)
	return
