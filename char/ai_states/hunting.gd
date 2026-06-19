class_name HuntingState
extends AiState

func get_state_name() -> String:
	return "Hunting"

func act(actor: Char) -> Array[Action]:
	# if the prey is dead, change prey or swap to wander
	if !is_instance_valid(actor.target_ch):
		# TODO: switch target if necessary
		actor.wander()
		return actor.curr_state.act(actor)
	var ret : Array[Action] = []
	
	# if reshuffle is necessary
	if actor.deck.primary == null:
		return [ReshuffleAction.new(actor)]
	
	# swap if necessary
	var primary_atk := 0
	var primary_def := 0
	var primary_range := 0
	var offhand_atk := 0
	var offhand_def := 0
	var offhand_range := 0
	
	var primary := actor.deck.primary
	var offhand := actor.deck.offhand
	
	if primary != null:
		primary_atk = primary.attack
		primary_def = primary.defense
		primary_range = primary.atk_range
	if offhand != null:
		offhand_atk = offhand.attack
		offhand_def = offhand.defense
		offhand_range = offhand.atk_range

	var is_close: bool = max(\
		abs(actor.grid_position.x - actor.target_ch.grid_position.x),\
		abs(actor.grid_position.y - actor.target_ch.grid_position.y)) <= 1

	if (primary_atk + offhand_def < offhand_atk + primary_def and is_close) or offhand_range > primary_range:
		actor.deck.swap()

	# can see the target
	if actor.target_ch in actor.visible_actors:
		# request target flow map
		actor.hunt_with_team(actor.target_ch)
		ret.push_back(AttackAction2.new(actor, actor.target_ch))
	else:
		if actor.target_flow_map.destination_reached(actor.grid_position):
			# if actor is within scent range, request a new target location
			var dist := Pathfinder.chebychev_dist(actor.grid_position, actor.target_ch.grid_position)
			
			if dist <= actor.scent_range:
				actor.hunt_with_team(actor.target_ch)
			else:
				actor.wander()
				return actor.curr_state.act(actor)
		ret.push_back(GoCloserAction.new(actor))
	return ret
