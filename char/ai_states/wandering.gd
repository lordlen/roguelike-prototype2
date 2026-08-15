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
	
	if len(actor.deck.discard_pile) != 0\
	and Globals.floor_map.get_tile(actor.grid_position).terrain_id == 3:
		return [ReshuffleAction.new(actor)]
	
	# if hasn't moved last turn, move elsewhere
	if actor.leader == actor and !actor.moved_last_turn:
		actor.wander_to_random()
		return [GoCloserAction.new(actor)]

	if actor.target_flow_map == null\
	or actor.target_flow_map.destination_reached(actor.grid_position):
		if actor.leader != actor:
			return []
		actor.wander_to_random()
	return [GoCloserAction.new(actor)]
