extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# get the adjacent tiles
	var adjacent_tiles := DijkstraMap._get_adjacent_edges(actor.grid_position)
	var water_count := 0
	for cell in adjacent_tiles + [actor.grid_position]:
		if Globals.floor_map.get_tile(cell) == RoomPattern.TileType.WATER:
			Globals.floor_map.update_tile(cell, RoomPattern.TileType.FLOOR)
			water_count += 1
	card.num_hits += water_count

	card_effect_finished.emit()
