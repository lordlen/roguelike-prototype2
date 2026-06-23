class_name FloorBuilder

const floor_descriptions := [
	"res://floor_generator/floor_description/floor_description/f1.tres",
	"res://floor_generator/floor_description/floor_description/f2.tres",
]

func build_floor(floor_id: int):
	var floor_description := load(floor_descriptions[floor_id]) as FloorDescription
	
	var room_patterns : Array[RoomPattern] = []
	for pattern_resource in floor_description.room_patterns:
		room_patterns.push_back(RoomPattern.new(pattern_resource))
	
	var simple_builder := SimpleBuilder.SimpleBuilderConstructor.new()\
		.set_dimensions(Vector2i(Terrain.width, Terrain.height))\
		.set_patterns(room_patterns)\
		.set_num_rooms(floor_description.num_rooms)\
		.construct()
	var map := Floor.new(Terrain.width, Terrain.height)
	map = simple_builder.build(map)
	
	var treasure_patterns : Array[RoomPattern]= []
	
	for pattern_resource in floor_description.treasure_patterns:
		treasure_patterns.push_back(RoomPattern.new(pattern_resource))

	var feature_builder := FeatureBuilder.FeatureBuilderConstructor.new()\
		.set_dimensions(Vector2i(Terrain.width, Terrain.height))\
		.set_patterns(treasure_patterns)\
		.set_num_features(floor_description.num_treasure)\
		.construct()
	map = feature_builder.build(map)
	
	var stairs_patterns : Array[RoomPattern]= []
	
	for pattern_resource in floor_description.stairs_patterns:
		stairs_patterns.push_back(RoomPattern.new(pattern_resource))
	
	var stairs_builder := SimpleBuilder.SimpleBuilderConstructor.new()\
		.set_dimensions(Vector2i(Terrain.width, Terrain.height))\
		.set_patterns(stairs_patterns)\
		.set_num_rooms(1)\
		.construct()
	
	map = stairs_builder.build(map)
	
	var result := map.get_all_tiles()

	Globals.floor_map = map
	
	# place the hero somewhere random
	var random_spawn_position := map.get_type_positions([
		RoomPattern.TileType.FLOOR,
		RoomPattern.TileType.GRASS
	])
	
	# TODO: take into account multiple controlled characters possibly
	for user in Globals.user_controlled:
		user.move_to(random_spawn_position.pick_random())
	
	# spawn the enemies
	ActorManager.spawn_initial_characters(floor_description.initial_spawns, floor_description.num_initial_spawns)
	
	# TODO: configure settings in actor manager
	ActorManager.configure_spawning(floor_description.subsequent_spawns, floor_description.turns_per_spawn)
