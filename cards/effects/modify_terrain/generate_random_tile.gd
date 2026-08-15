extends CardEffect

@export var tile_type: TileResource
@export var valid_tile_types: Array[TileResource.Terrains]
@export var num_gen: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# find a floor tile in an adjacent tile
	var adj := DijkstraMap._get_adjacent_edges(target_char.grid_position)
	var valid_tiles: Array[Vector2i] = []
	for cell in adj + [target_char.grid_position]:
		if Globals.floor_map.get_tile(cell).terrain_id in valid_tile_types:
			valid_tiles.push_back(cell)

	if valid_tiles.is_empty():
		card_effect_finished.emit()
		return
	valid_tiles.shuffle()
	for i in range(min(num_gen, len(valid_tiles))):
		Globals.floor_map.update_tile(valid_tiles[i], tile_type)
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%d %s" % [num_gen, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [num_gen, super.get_shortform(card)]
