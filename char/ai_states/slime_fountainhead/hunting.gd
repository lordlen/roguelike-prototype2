class_name FountainheadHuntingState
extends HuntingState
		
func has_water(actor):
	var adjacent_tiles := DijkstraMap._get_adjacent_edges(actor.grid_position)
	for cell in adjacent_tiles + [actor.grid_position]:
		if Globals.floor_map.get_tile(cell).terrain_id == 3:
			return true
	return false

func should_reshuffle(actor: Char):
	return super.should_reshuffle(actor) or actor.deck.primary and\
	actor.deck.primary.card_name == "Water Ball" and !has_water(actor)
