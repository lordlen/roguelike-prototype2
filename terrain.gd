extends TileMapLayer

const width := 70
const height := 40

# Called when the node enters the scene tree for the first time.

func initialize_floor():
	var room_patterns : Array[RoomPattern] = [
		RoomPattern.new(load(RoomPattern.room_outline_resource.checker_grass) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.croissant) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.diamond) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.hut) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.L) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.lake) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.long_corridor) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.pillar) as PatternResource),
		RoomPattern.new(load(RoomPattern.room_outline_resource.river) as PatternResource),
	]
	
	var simple_builder := SimpleBuilder.SimpleBuilderConstructor.new()\
		.set_dimensions(Vector2i(width, height))\
		.set_patterns(room_patterns)\
		.set_num_rooms(30)\
		.construct()
	var map := Floor.new(width, height)
	map = simple_builder.build(map)
	
	var treasure_patterns : Array[RoomPattern]= [
		RoomPattern.new(load(RoomPattern.feature_resource.vault) as PatternResource),
		RoomPattern.new(load(RoomPattern.feature_resource.island) as PatternResource),
	]
	var feature_builder := FeatureBuilder.FeatureBuilderConstructor.new()\
		.set_dimensions(Vector2i(width, height))\
		.set_patterns(treasure_patterns)\
		.set_num_features(2)\
		.construct()
	map = feature_builder.build(map)
	
	var result := map.get_all_tiles()

	Globals.floor_map = map
	
	# set all terrain to a wall
	var walls : Array[Vector2i] = []
	for x in range(width):
		for y in range(height):
			walls.push_back(Vector2i(x,y))
	
	self.set_cells_terrain_connect(walls, 0, 1)
	
	walls.clear()
	var floors : Array[Vector2i] = []
	var grasses : Array[Vector2i] = []
	var waters : Array[Vector2i] = []
	var pedestals: Array[Vector2i] = []
	
	for c in result:
		match result[c]:
			RoomPattern.TileType.FLOOR:
				floors.push_back(c)
			RoomPattern.TileType.WALL:
				walls.push_back(c)
			RoomPattern.TileType.WATER:
				waters.push_back(c)
			RoomPattern.TileType.GRASS:
				grasses.push_back(c)
			RoomPattern.TileType.PEDESTAL:
				pedestals.push_back(c)
			_:
				pass
	self.set_cells_terrain_connect(floors, 0, 0)
	self.set_cells_terrain_connect(walls, 0, 1)
	self.set_cells_terrain_connect(grasses, 0, 2)
	self.set_cells_terrain_connect(waters, 0, 3)
	self.set_cells_terrain_connect(pedestals, 0, 4)
