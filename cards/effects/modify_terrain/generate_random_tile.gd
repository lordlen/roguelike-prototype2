class_name GenerateRandomTile
extends CardEffect

@export var num_gen: int = 1
@export var radius: int = 1
@export var target: Target = Target.SELF

@export_group("Fixed")
@export var tile_type: TileResource
@export var valid_tile_types: Array[TileResource.Terrains]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor.grid_position if target == Target.SELF else target_pos
	var adj_tiles := Globals.floor_map.get_area(t, radius)
	var valid_tiles := Globals.floor_map.get_type_positions_in_area(valid_tile_types, adj_tiles)
	valid_tiles.shuffle()
	for i in range(min(num_gen, len(valid_tiles))):
		Globals.floor_map.update_tile(valid_tiles[i], tile_type)
	card_effect_finished.emit()
