class_name Cultivate
extends GenerateRandomTile

func _init() -> void:
	tile_type = load("res://floor_generator/tiles/grass.tres")
	valid_tile_types = [
	TileResource.Terrains.GROUND,
	TileResource.Terrains.TRAMPLED_GRASS,
	TileResource.Terrains.WATER,
]

func get_identifier() -> String:
	return "cultivate" if target == Target.ENEMY else "self-cultivate"
	
func get_description() -> String:
	return 'Create n grass tile(s).'

func get_numeric() -> String:
	return "n"

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [num_gen, super.get_shortform(card)]
