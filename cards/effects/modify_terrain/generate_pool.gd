extends CardEffect

@export var num_tiles: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# find a floor tile in an adjacent tile
	var adj := DijkstraMap._get_adjacent_edges(target_char.grid_position)
	var valid_tiles: Array[Vector2i] = []
	for cell in adj + [target_char.grid_position]:
		var tile = Globals.floor_map.get_tile(cell)
		if tile.terrain_id in [0, 2, 5]:
			valid_tiles.push_back(cell)
	var water_tile := load("res://floor_generator/tiles/water.tres")
	for i in range(num_tiles):
		if valid_tiles.is_empty():
			card_effect_finished.emit()
			break
		var random_cell : Vector2i = valid_tiles.pick_random()
		Globals.floor_map.update_tile(random_cell, water_tile)
		valid_tiles.erase(random_cell)
	card_effect_finished.emit()
