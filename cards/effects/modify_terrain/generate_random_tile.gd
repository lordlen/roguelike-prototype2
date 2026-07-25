extends CardEffect

@export var tile_type: RoomPattern.TileType

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# find a floor tile in an adjacent tile
	var adj := DijkstraMap._get_adjacent_edges(actor.grid_position)
	var valid_tiles: Array[Vector2i] = []
	for cell in adj:
		var tile = Tiles.TileDictionary[Globals.floor_map.get_tile(cell)]
		if is_instance_of(tile, Tiles.Ground):
			valid_tiles.push_back(cell)

	if valid_tiles.is_empty():
		card_effect_finished.emit()
		return
	var random_cell : Vector2i = valid_tiles.pick_random()
	Globals.floor_map.update_tile(random_cell, tile_type)
	card_effect_finished.emit()
