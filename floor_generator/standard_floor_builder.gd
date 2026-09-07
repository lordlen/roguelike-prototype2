class_name StandardFloorBuilder
extends FloorBuilder

@export var floor_description: FloorDescription

func build_floor():
	ActorManager.clear_ai_controlled()
	ItemManager.clear_items()
	
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
	
	# determine how many rooms there are
	var num_potions := get_random_number(floor_description.potion_ratio)
	var num_gold := get_random_number(floor_description.gold_ratio)
	
	# place 2 cards randomly
	# get floor tiles
	var ground_positions := map.get_type_positions([TileResource.Terrains.GROUND])
	ground_positions.shuffle()
	
	var num_card_rewards := 2
	for cell in ground_positions.slice(0, num_card_rewards):
		# get the rarity according to the card reward generator
		var rarity := card_reward_generator.generate_rarity()
		var card_item := load(CardRewardItem.resource_mapping[rarity])
		ItemManager.add_item_to_overworld(card_item, cell)
	
	for cell in ground_positions.slice(num_card_rewards):
		var valid_tiles := [
			TileResource.Terrains.GROUND,
			TileResource.Terrains.TRAMPLED_GRASS,
			TileResource.Terrains.GRASS,
		]
		var is_valid := true
		for adj_cell in DijkstraMap._get_adjacent_edges(cell):
			if map.get_tile(adj_cell).terrain_id not in valid_tiles:
				is_valid = false
				break
		
		if is_valid:
			var stairs := load("res://floor_generator/tiles/stairs.tres")
			map.set_tile(cell, stairs)
			break

	var result := map.get_all_tiles()
	
	# place the hero somewhere random
	var random_spawn_position := map.get_type_positions([
		TileResource.Terrains.GROUND,
		TileResource.Terrains.GRASS,
		TileResource.Terrains.TRAMPLED_GRASS
	])
	
	Globals.floor_map = map

	# TODO: take into account multiple controlled characters possibly
	for user in Globals.user_controlled:
		user.move_to(random_spawn_position.pick_random())
	
	# spawn the enemies
	var gold : Gold = load("res://items/gold/gold.tres")
	gold.amount = randi_range(15, 45)
	ActorManager.spawn_initial_characters(floor_description.initial_spawns, num_gold, [gold])
	var potion := floor_description.item_pool.get_item()
	ActorManager.spawn_initial_characters(floor_description.initial_spawns, num_potions, [potion])
	ActorManager.spawn_initial_characters(floor_description.initial_spawns, floor_description.num_initial_spawns - num_gold - num_potions)
	var elite_card_reward := load(CardRewardItem.resource_mapping[card_reward_generator.generate_rarity()])
	ActorManager.spawn_initial_characters(floor_description.elite_spawns,floor_description.num_elite_spawns, [elite_card_reward], true)
	ActorManager.configure_spawning(floor_description.initial_spawns, floor_description.turns_per_spawn)

	# generate any special rooms. Avoid characters from spawning here.
	var special_rooms : Array[RoomPattern] = []
	for pattern_resource in floor_description.special_patterns:
		special_rooms.push_back(RoomPattern.new(pattern_resource))
	
	var special_builder := SimpleBuilder.SimpleBuilderConstructor.new()\
		.set_dimensions(Vector2i(Terrain.width, Terrain.height))\
		.set_patterns(special_rooms)\
		.set_num_rooms(floor_description.num_special_rooms)\
		.set_connect_close_rooms(false)\
		.construct()
	Globals.floor_map = special_builder.build(Globals.floor_map)
	
	## put a relic in the pressure plate
	#var pressure_plate_positions := map.get_type_positions([
		#TileResource.Terrains.PEDESTAL
	#])
	#for pos in pressure_plate_positions:
		## get relic without replacement
		#var item := floor_description.relic_pool.get_item()
		#ItemManager.add_item_to_overworld(item, pos)
	
func get_random_number(val: float) -> int:
	var num : int = floor(val)
	var prob : float = fmod(val, 1.0)
	if randf() < prob:
		num += 1
	return num
