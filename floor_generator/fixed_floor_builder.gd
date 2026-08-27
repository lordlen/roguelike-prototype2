class_name FixedFloorBuilder
extends FloorBuilder

@export var floor_layout_resource: PatternResource
@export var floor_layout_dijkstra: PatternResource
@export var hero_spawn_point: Vector2i
@export var spawn_groups: Array[SpawnGroup]
@export var positions: Array[Vector2i]
@export_group("Items")
@export_subgroup("Generators")
@export var potion_pool: ItemPoolDescription
@export var card_pool: CardRewardGenerator
@export var relic_pool: ItemPoolDescription
@export var healing_tile: ActivationTile
@export_subgroup("Amount")
@export var num_potions: int
@export var num_cards: int
@export var num_relics: int
@export var num_healing: int
@export_subgroup("Cost")
@export var potion_cost: int
@export var card_cost: int
@export var relic_cost: int
@export var healing_cost: int

func build_floor():
	ItemManager.clear_items()
	ActorManager.clear_ai_controlled()
	
	var map := Floor.new(Terrain.width, Terrain.height)
	var floor_layout := RoomPattern.new(floor_layout_resource)
	var floor_dijkstra := RoomPattern.new(floor_layout_dijkstra)
	
	map.append_back(floor_layout.used_cells, floor_layout.get_cell_types())
	map.add_dijkstra_map(floor_dijkstra.used_cells)
	
	Globals.floor_map = map
	
	# move hero to spawn point
	for char in ActorManager.get_user_controlled_chars():
		char.move_to(hero_spawn_point)
	
	# spawn the spawn group in a location
	for i in range(len(spawn_groups)):
		var spawn_group := spawn_groups[i]
		var pos := positions[i]
		
		for char_stats in spawn_group.group:
			var c := ActorManager.spawn_character(char_stats)
			c.move_to(pos)
	
	# find all the "pedestals" and place 
	var p_positions := Globals.floor_map.get_type_positions([TileResource.Terrains.PEDESTAL])
	var p_ind := 0
	for i in range(num_potions):
		if p_ind >= len(p_positions):
			break
		var item := potion_pool.get_random_item()
		
		ItemManager.add_item_to_overworld(item, p_positions[p_ind], potion_cost)
		
		p_ind += 1
	
	for i in range(num_relics):
		if p_ind >= len(p_positions):
			break
		var item := relic_pool.get_random_item_no_replacement()
		
		ItemManager.add_item_to_overworld(item, p_positions[p_ind], relic_cost)
		
		p_ind += 1
	
	var cards := card_pool.generate_card_rewards(num_cards)
	for card in cards:
		if p_ind >= len(p_positions):
			break
		var item := CardItem.new()
		item.set_card(card)
		
		ItemManager.add_item_to_overworld(item, p_positions[p_ind], card_cost)
		
		p_ind += 1
	
	for i in range(num_healing):
		if p_ind >= len(p_positions):
			break
		
		ItemManager.add_item_to_overworld(
			healing_tile, p_positions[p_ind], healing_cost)

		p_ind += 1
