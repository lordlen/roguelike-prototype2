class_name Backslide
extends CardEffect

@export var distance: int = 1

func get_identifier() -> String:
	return "backslide"
	
func get_description() -> String:
	return 'Move back n tile(s).'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# subtract the target and actor location
	# push the target back x amount of tiles.
	var line_iterator:= BresenhamIterator.new(target_char.grid_position, actor.grid_position, distance)
	var curr_pos := actor.grid_position
	for pos in line_iterator:
		# check if position is occupied by a wall or char
		if ActorManager.get_actor_in_position(pos) != null\
		or Globals.floor_map.get_tile(pos).get_pf_cost(actor.traversal) == INF:
			break
		
		curr_pos = pos
	actor.char_move_effect.emit()
	actor.move_to(curr_pos)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [distance, super.get_shortform(card)]
