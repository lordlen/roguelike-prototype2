class_name Terrain
extends TileMapLayer

const width := 70
const height := 40

func _ready() -> void:
	EventBus.floor_tile_updated.connect(on_tile_updated)

func on_tile_updated(cell: Vector2i, tile: TileResource):
	self.set_cells_terrain_connect([cell], 0, tile.terrain_id)

func draw_tiles(tiles: Dictionary[Vector2i, TileResource]):
	# set all terrain to a wall
	var walls : Array[Vector2i] = []
	for x in range(width):
		for y in range(height):
			walls.push_back(Vector2i(x,y))
	
	self.set_cells_terrain_connect(walls, 0, 1)
	
	walls.clear()
	var tile_array = []
	for tile_type_ind in range(TileResource.Terrains.values().max() + 1):
		tile_array.push_back([])
	
	for c in tiles:
		var ind = tiles[c].terrain_id
		tile_array[ind].push_back(c)
	
	for terrain_ind in range(len(tile_array)):
		self.set_cells_terrain_connect(tile_array[terrain_ind], 0, terrain_ind)
