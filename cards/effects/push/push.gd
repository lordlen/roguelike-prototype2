class_name Push
extends CardEffect

@export var push_amount : int = 2

func get_identifier() -> String:
	return "push"
	
func get_description() -> String:
	return 'Push target by n tiles'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# push the target back x amount of tiles.
	var line_iterator:= BresenhamIterator.new(actor.grid_position, target_char.grid_position, push_amount)
	var curr_pos := target_char.grid_position
	for pos in line_iterator:
		# check if position is occupied by a wall or char
		if ActorManager.get_actor_in_position(pos) != null\
		or Globals.floor_map.get_tile(pos).get_pf_cost(target_char.traversal) == INF:
			break
		
		curr_pos = pos
	target_char.move_to(curr_pos)
	card_effect_finished.emit()
			

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [push_amount, super.get_shortform(card)]
