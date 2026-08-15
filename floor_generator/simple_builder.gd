class_name SimpleBuilder
extends MapBuilder

class SimpleBuilderConstructor:
	var size : Vector2i
	var patterns: Array[RoomPattern]
	var num_rooms: int
	var do_connect: bool = true

	func set_dimensions(v: Vector2i) -> SimpleBuilderConstructor:
		size = v
		return self
	
	func set_patterns(patterns: Array[RoomPattern]) -> SimpleBuilderConstructor:
		self.patterns = patterns
		return self
	
	func set_num_rooms(num_rooms: int) -> SimpleBuilderConstructor:
		self.num_rooms = num_rooms
		return self
	
	func set_connect_close_rooms(do_connect: bool) -> SimpleBuilderConstructor:
		self.do_connect = do_connect
		return self

	func construct() -> SimpleBuilder:
		return SimpleBuilder.new(size.x, size.y, patterns, num_rooms, do_connect)
		
var width: int
var height: int
var patterns: Array[RoomPattern]
var rooms: int
var connect_close_rooms: bool

func _init(width: int, height: int, patterns: Array[RoomPattern], rooms: int, connect_close_rooms: bool) -> void:
	self.width = width
	self.height = height
	self.patterns = patterns
	self.rooms = rooms
	self.connect_close_rooms = connect_close_rooms

func build(floor: Floor) -> Floor:
	var successful_room_placement := 0
	var failed_attempts := 0
	var fail_limit := 200
	var distance_threshold := 15
	
	while successful_room_placement < rooms and failed_attempts < fail_limit:
		if floor.used_cells.is_empty():
			# first room
			# pick the mid point
			var mid := Vector2i(width / 2, height / 2)
			
			# pick random pattern out of the list
			var first_dir : Vector2i= [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT].pick_random()
			var first_pattern : RoomPattern = patterns.pick_random()
			floor.append_back(first_pattern.get_used_cells(first_dir, mid), first_pattern.get_cell_types())
			successful_room_placement += 1
			continue
		
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
	
	if connect_close_rooms:
		var floor_tile := load("res://floor_generator/tiles/ground.tres")
		var num_attempts = 0
		var max_attempts = 1000
		# pick 2 random floor tiles
		var floor_positions := floor.get_type_positions([TileResource.Terrains.GROUND])
		while num_attempts < max_attempts:
			# get 2 random floor tiles
			var cell1 : Vector2i = floor_positions.pick_random()
			var cell2 : Vector2i = floor_positions.pick_random()
			
			var chev_dist := Pathfinder.chebychev_dist(cell1, cell2)
			var true_dist := len(floor.compute_path(cell1, cell2))
			
			if chev_dist * 3 < true_dist:
				# connect the two
				# randomly select whether we want x or y first
				var corridor_tiles : Array[Vector2i] = []
				var tile_types: Array[TileResource] = []
				var x_inc = 1 if cell1.x < cell2.x else -1
				var y_inc = 1 if cell1.y < cell2.y else -1
				for x in range(cell1.x, cell2.x + x_inc, x_inc):
					corridor_tiles.push_back(Vector2i(x, cell1.y))
					tile_types.push_back(floor_tile)
				for y in range(cell1.y + y_inc, cell2.y + y_inc, y_inc):
					corridor_tiles.push_back(Vector2i(cell2.x, y))
					tile_types.push_back(floor_tile)
				floor.append_back(corridor_tiles, tile_types)
			else:
				num_attempts += 1
	
	var ca_generator = CellularAutomataGenerator.new(width, height, 0.20, 7)
	var grass := ca_generator.build()

	var grass_resource := load("res://floor_generator/tiles/grass.tres")
	for x in range(width):
		for y in range(height):
			var v := Vector2i(x,y)
			if floor.get_tile(v).terrain_id in [0] and v in grass:
				floor.set_tile(v, grass_resource)

	## set water
	#var water_generator := WaterGenerator.new(width, height)
	#var water := water_generator.build()
	#
	#for cell in water:
		#floor.set_tile(cell, RoomPattern.TileType.WATER)

	# instantiate the dijkstra maps
	floor.initialize_all_dijkstra_maps()
	return floor
