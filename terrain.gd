class_name Terrain
extends TileMapLayer

const width := 70
const height := 40

static var TerrainIndexDictionary : Dictionary[RoomPattern.TileType, int] = {
	RoomPattern.TileType.UNOCCUPIED: 1,
	RoomPattern.TileType.FLOOR: 0,
	RoomPattern.TileType.WALL: 1,
	RoomPattern.TileType.GRASS: 2,
	RoomPattern.TileType.WATER: 3,
	RoomPattern.TileType.PEDESTAL: 4,
	RoomPattern.TileType.TRAMPLED_GRASS: 5,
	RoomPattern.TileType.STAIRS: 6
}

func _ready() -> void:
	EventBus.connect("floor_tile_updated", on_tile_updated)

func on_tile_updated(cell: Vector2i, tile_type: RoomPattern.TileType):
	self.set_cells_terrain_connect([cell], 0, TerrainIndexDictionary[tile_type])

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
	
	draw_tiles(result)

func draw_tiles(tiles: Dictionary[Vector2i, RoomPattern.TileType]):
	# set all terrain to a wall
	var walls : Array[Vector2i] = []
	for x in range(width):
		for y in range(height):
			walls.push_back(Vector2i(x,y))
	
	self.set_cells_terrain_connect(walls, 0, 1)
	
	walls.clear()
	var tile_array = []
	for tile_type_ind in range(7):
		tile_array.push_back([])
	
	for c in tiles:
		var ind = TerrainIndexDictionary[tiles[c]]
		tile_array[ind].push_back(c)
	
	for terrain_ind in range(len(tile_array)):
		self.set_cells_terrain_connect(tile_array[terrain_ind], 0, terrain_ind)
