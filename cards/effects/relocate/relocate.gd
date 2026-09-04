class_name Relocate
extends CardEffect

func get_identifier() -> String:
	return "relocate"
	
func get_description() -> String:
	return 'Relocate to the target.'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# assume that this only gets called if the attacker is in range
	# get the path in a straight line
	var pf := Pathfinder.new()
	var path := pf.get_straight_path_actor(actor.grid_position, target_char.grid_position, actor.traversal)
	
	# no need to move if the target is 1 tile away
	if len(path) < 2:
		card_effect_finished.emit()
		return
	
	actor.char_move_effect.emit()
	# get the last 
	actor.move_to(path[- 1])
	# await actor.char_finished_moving
	card_effect_finished.emit()
