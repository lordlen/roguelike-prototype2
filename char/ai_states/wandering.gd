class_name WanderingState
extends AiState

func get_state_name() -> String:
	return "Wandering"

func act(actor: Char) -> Array[Action]:
	var enemy_seen := actor
	for ch: Char in actor.visible_actors:
		if ch.alignment != actor.alignment:
			# swap states
			enemy_seen = ch
			break
	if enemy_seen != actor:
		actor.hunt_with_team(enemy_seen)
		return actor.curr_state.act(actor)
	
	if len(actor.deck.discard_pile) != 0:
		return [ReshuffleAction.new(actor)]

	if actor.target_flow_map == null\
	or actor.target_flow_map.destination_reached(actor.grid_position):
		if actor.leader != actor:
			return []
		# var valid_positions := Globals.floor_map.get_type_positions(actor.get_traversable_tiles())
		# actor.wander_to(valid_positions.pick_random())
		actor.wander_to_random()
	return [GoCloserAction.new(actor)]
