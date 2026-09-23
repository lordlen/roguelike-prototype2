class_name Terrain
extends Node2D

const width := 70
const height := 40

@export var terrain_set := 0

@onready var terrain_top := $TerrainTop
@onready var terrain_bottom := $TerrainBottom

func _ready() -> void:
	EventBus.floor_tile_updated.connect(on_tile_updated)

func on_tile_updated(cell: Vector2i, tile: TileResource):
	terrain_top.set_cells_terrain_connect([cell], terrain_set, tile.top_id)
	terrain_bottom.set_cells_terrain_connect([cell], terrain_set, tile.bottom_id)

func draw_tiles(tiles: Dictionary[Vector2i, TileResource]):
	# set all terrain to a wall
	var walls : Array[Vector2i] = []
	for x in range(width):
		for y in range(height):
			walls.push_back(Vector2i(x,y))
	
	terrain_top.set_cells_terrain_connect(walls, terrain_set, TileResource.Tops.WALL)
	terrain_bottom.set_cells_terrain_connect(walls, terrain_set, TileResource.Bottoms.SOIL)

	var top_tile_array = []
	var bottom_tile_array = []
	for tile_type_ind in range(TileResource.Tops.values().max() + 1):
		top_tile_array.push_back([])
	
	for tile_type_ind in range(TileResource.Bottoms.values().max() + 1):
		bottom_tile_array.push_back([])
	
	for c in tiles:
		top_tile_array[tiles[c].top_id].push_back(c)
		bottom_tile_array[tiles[c].bottom_id].push_back(c)

	for terrain_ind in range(len(top_tile_array)):
		terrain_top.set_cells_terrain_connect(top_tile_array[terrain_ind], terrain_set, terrain_ind)
	
	for terrain_ind in range(len(bottom_tile_array)):
		terrain_bottom.set_cells_terrain_connect(bottom_tile_array[terrain_ind], terrain_set, terrain_ind)
