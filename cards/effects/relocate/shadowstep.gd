class_name Shadowstep
extends CardEffect

func get_identifier() -> String:
	return "shadowstep"
	
func get_description() -> String:
	return 'Relocate behind the target.'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# assume that this only gets called if the attacker is in range
	# get the path in a straight line
	var pf := Pathfinder.new()
	var path := pf.get_straight_path(actor.grid_position, target_char.grid_position, actor.traversal)

	var behind := target_char.grid_position + path[1] - path[0]
	# check if "behind" is occupied.
	var occupying_actor := ActorManager.get_actor_in_position(behind)
	if occupying_actor != null or Globals.floor_map.get_tile(behind).get_pf_cost(actor.traversal) == INF:
		# do nothing
		pass
	else:
		actor.char_move_effect.emit()
		# get the last 
		actor.move_to(behind)
	# await actor.char_finished_moving
	card_effect_finished.emit()
