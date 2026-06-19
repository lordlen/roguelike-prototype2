class_name SimpleBuilder
extends MapBuilder

class SimpleBuilderConstructor:
	var size : Vector2i
	var patterns: Array[RoomPattern]
	var num_rooms: int

	func set_dimensions(v: Vector2i) -> SimpleBuilderConstructor:
		size = v
		return self
	
	func set_patterns(patterns: Array[RoomPattern]) -> SimpleBuilderConstructor:
		self.patterns = patterns
		return self
	
	func set_num_rooms(num_rooms: int) -> SimpleBuilderConstructor:
		self.num_rooms = num_rooms
		return self

	func construct() -> SimpleBuilder:
		return SimpleBuilder.new(size.x, size.y, patterns, num_rooms)
		
var width: int
var height: int
var patterns: Array[RoomPattern]
var rooms: int
func _init(width: int, height: int, patterns: Array[RoomPattern], rooms: int) -> void:
	self.width = width
	self.height = height
	self.patterns = patterns
	self.rooms = rooms

func build(floor: Floor) -> Floor:
	var successful_room_placement := 0
	var failed_attempts := 0
	var fail_limit := 200
	var distance_threshold := 20
	
	# first room
	# pick the mid point
	var mid := Vector2i(width / 2, height / 2)
	
	# pick random pattern out of the list
	var first_dir : Vector2i= [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
	var first_pattern : RoomPattern = patterns.pick_random()
	floor.append_back(first_pattern.get_used_cells(first_dir, mid), first_pattern.get_cell_types())
	successful_room_placement += 1
	
	while successful_room_placement < rooms and failed_attempts < fail_limit:
		# from the floor, pick a random valid wall that 
		var r_result = floor.get_random_wall()

		var wall : Vector2i = r_result[0]
		var dir : Vector2i = r_result[1]
		
		# pick random pattern
		var pattern : RoomPattern = patterns.pick_random()
		var points := pattern.get_used_cells(dir, wall)
		
		if floor.is_no_point_overlap(points):
			floor.append_back(points, pattern.get_cell_types())
			floor.add_dijkstra_map(points)
			successful_room_placement += 1
			failed_attempts = 0
		else:
			failed_attempts += 1
	
	# Add cycles.
	# first, find all wall tiles where there is a floor tile on 2 opposite sides
	# for each side, compute the cost using A star. If it's too far, then remove the wall
	
	# loop through all tiles and find a wall with a
	for x in range(width):
		for y in range(height):
			var v := Vector2i(x,y)
			if floor.get_tile(v + Vector2i.LEFT) != RoomPattern.TileType.UNOCCUPIED\
			and floor.get_tile(v + Vector2i.RIGHT) != RoomPattern.TileType.UNOCCUPIED:
				var cost = len(floor.compute_path(v + Vector2i.LEFT, v + Vector2i.RIGHT))
				if cost >= distance_threshold:
					floor.set_tile(v, RoomPattern.TileType.FLOOR)
			
			if floor.get_tile(v + Vector2i.UP) != RoomPattern.TileType.UNOCCUPIED\
			and floor.get_tile(v + Vector2i.DOWN) != RoomPattern.TileType.UNOCCUPIED:
				var cost = len(floor.compute_path(v + Vector2i.UP, v + Vector2i.DOWN))
				if cost >= distance_threshold:
					floor.set_tile(v, RoomPattern.TileType.FLOOR)
	
	var ca_generator = CellularAutomataGenerator.new(width, height, 0.30, 5)
	var grass := ca_generator.build()
	
	for x in range(width):
		for y in range(height):
			var v := Vector2i(x,y)
			if floor.get_tile(v) == RoomPattern.TileType.FLOOR and v in grass:
				floor.set_tile(v, RoomPattern.TileType.GRASS)
	
	## set water
	#var water_generator := WaterGenerator.new(width, height)
	#var water := water_generator.build()
	#
	#for cell in water:
		#floor.set_tile(cell, RoomPattern.TileType.WATER)

	# instantiate the dijkstra maps
	floor.initialize_all_dijkstra_maps()
	return floor
