class_name Flood
extends GenerateRandomTile

func _init() -> void:
	tile_type = load("res://floor_generator/tiles/water.tres")
	valid_tile_types = [
	TileResource.Terrains.GROUND,
	TileResource.Terrains.TRAMPLED_GRASS,
	TileResource.Terrains.GRASS,
]

func get_identifier() -> String:
	return "flood" if target == Target.ENEMY else "self-flood"
	
func get_description() -> String:
	return 'Create n water tile(s).'

func get_numeric() -> String:
	return "n"

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [num_gen, super.get_shortform(card)]
