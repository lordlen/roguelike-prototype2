extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# get the adjacent tiles
	var adjacent_tiles := DijkstraMap._get_adjacent_edges(actor.grid_position)
	var grass_count := 0
	for cell in adjacent_tiles + [actor.grid_position]:
		if Globals.floor_map.get_tile(cell) == RoomPattern.TileType.GRASS:
			Globals.floor_map.update_tile(cell, RoomPattern.TileType.TRAMPLED_GRASS)
			grass_count += 1
	card.num_hits += grass_count

	card_effect_finished.emit()
