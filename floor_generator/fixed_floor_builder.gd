class_name FixedFloorBuilder
extends FloorBuilder

@export var floor_layout_resource: PatternResource
@export var floor_layout_dijkstra: PatternResource
@export var hero_spawn_point: Vector2i
@export var spawn_groups: Array[SpawnGroup]
@export var positions: Array[Vector2i]

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
			Char.new(char_stats, pos)
