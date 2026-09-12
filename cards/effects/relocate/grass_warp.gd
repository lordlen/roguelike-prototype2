class_name GrassWarp
extends CardEffect

@export var radius: int = 3

func get_identifier() -> String:
	return "grass_warp"
	
func get_description() -> String:
	return 'Relocate to a random grass tile within n radius.'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var area := Globals.floor_map.get_area(actor.grid_position, radius)
	# find the valid tiles
	var valid_positions := Globals.floor_map.get_type_positions_in_area([
		TileResource.Terrains.GRASS
	], area)
	
	if len(valid_positions) > 0:
		actor.char_move_effect.emit()
		actor.move_to(valid_positions.pick_random())
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [radius, super.get_shortform(card)]
