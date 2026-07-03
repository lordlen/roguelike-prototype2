class_name FloorBuilder

const floor_descriptions := [
	# "res://floor_generator/floor_description/floor_description/test_floor.tres",
	"res://floor_generator/floor_description/floor_description/f0.tres",
	"res://floor_generator/floor_description/floor_description/f1.tres",
	"res://floor_generator/floor_description/floor_description/f2.tres",
	"res://floor_generator/floor_description/floor_description/f3.tres",
	"res://floor_generator/floor_description/floor_description/f4.tres",
]

func build_floor(floor_id: int):
	ItemManager.clear_items()
	ActorManager.clear_ai_controlled()
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
	
	var special_patterns : Array[RoomPattern]= []
	
	for pattern_resource in floor_description.special_patterns:
		special_patterns.push_back(RoomPattern.new(pattern_resource))
	
	# determine how many rooms there are
	var num_potions := get_random_number(floor_description.potion_ratio)
	var num_gold := get_random_number(floor_description.gold_ratio)
	var num_shrine := get_random_number(floor_description.shrine_ratio)
	
	var num_loot_rooms := num_potions + num_gold + num_shrine
	
	var special_builder := SimpleBuilder.SimpleBuilderConstructor.new()\
		.set_dimensions(Vector2i(Terrain.width, Terrain.height))\
		.set_patterns(special_patterns)\
		.set_num_rooms(num_loot_rooms)\
		.set_connect_close_rooms(false)\
		.construct()
	
	map = special_builder.build(map)
	
	# find all the pedestals
	var special_positions := map.get_type_positions([RoomPattern.TileType.PEDESTAL])
	for i in range(num_potions):
		var item : Item = floor_description.item_pool.get_random_item()
		var pos : Vector2i = special_positions.pop_back()
		ItemManager.add_item_to_overworld(item, pos)
		# remove the pedestal
		map.update_tile(pos, RoomPattern.TileType.FLOOR)
	
	for i in range(num_gold):
		# TODO: get a variable number of gold
		var item : Gold = load("res://items/gold/gold.tres")
		item.amount = 100
		var pos : Vector2i = special_positions.pop_back()
		ItemManager.add_item_to_overworld(item, pos)
		map.update_tile(pos, RoomPattern.TileType.FLOOR)
	
	for i in range(num_shrine):
		var item : Item = floor_description.shrine_pool.get_random_item()
		var pos : Vector2i = special_positions.pop_back()
		ItemManager.add_item_to_overworld(item, pos)
		# remove the pedestal
		map.update_tile(pos, RoomPattern.TileType.FLOOR)

	var stairs_patterns : Array[RoomPattern]= []

	for pattern_resource in floor_description.stairs_patterns:
		stairs_patterns.push_back(RoomPattern.new(pattern_resource))

	var stairs_builder := SimpleBuilder.SimpleBuilderConstructor.new()\
		.set_dimensions(Vector2i(Terrain.width, Terrain.height))\
		.set_patterns(stairs_patterns)\
		.set_num_rooms(1)\
		.set_connect_close_rooms(false)\
		.construct()
	
	map = stairs_builder.build(map)
	
	# place 2 cards randomly
	# get floor tiles
	var ground_positions := map.get_type_positions([RoomPattern.TileType.FLOOR])
	ground_positions.shuffle()
	
	var num_card_rewards := 2
	var card_item := load("res://items/card_item/card_item.tres")
	for cell in ground_positions.slice(0, num_card_rewards):
		ItemManager.add_item_to_overworld(card_item, cell)

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
	ActorManager.spawn_initial_characters(floor_description.elite_spawns,floor_description.num_elite_spawns, true)
	ActorManager.configure_spawning(floor_description.subsequent_spawns, floor_description.turns_per_spawn)

func get_random_number(val: float) -> int:
	var num : int = floor(val)
	var prob : float = fmod(val, 1.0)
	if randf() < prob:
		num += 1
	return num
