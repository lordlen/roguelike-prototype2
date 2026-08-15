extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# get the adjacent tiles
	var adjacent_tiles := DijkstraMap._get_adjacent_edges(actor.grid_position)
	var water_count := 0
	var ground_tile := load("res://floor_generator/tiles/ground.tres")
	for cell in adjacent_tiles + [actor.grid_position]:
		if Globals.floor_map.get_tile(cell).terrain_id == 3:
			Globals.floor_map.update_tile(cell, ground_tile)
			water_count += 1
	card.num_hits += water_count

	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
