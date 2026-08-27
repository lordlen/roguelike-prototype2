extends Relic

func on_took_damage(actor: Char):
	# get all adjacent opposing characters
	var adj_positions := DijkstraMap._get_adjacent_edges(actor.grid_position)
	for char in ActorManager.get_actors_in_positions(adj_positions):
		if char.alignment != actor.alignment:
			char.take_damage(1)
