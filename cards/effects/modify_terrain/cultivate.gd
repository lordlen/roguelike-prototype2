class_name Cultivate
extends CardEffect

@export var num_gen: int
@export var target: Target

func get_identifier() -> String:
	return "cultivate" if target == Target.ENEMY else "self-cultivate"
	
func get_description() -> String:
	return 'Create n grass tile(s).'

func get_numeric() -> String:
	return "n"

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [num_gen, super.get_shortform(card)]

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var generator := GenerateRandomTile.new()
	generator.num_gen = num_gen
	generator.radius = 1
	generator.target = target
	generator.tile_type = load("res://floor_generator/tiles/grass.tres")
	generator.valid_tile_types = [
		TileResource.Terrains.GROUND,
		TileResource.Terrains.TRAMPLED_GRASS,
		TileResource.Terrains.WATER,
	]
	generator.do(actor, target_char, card)
	card_effect_finished.emit()
