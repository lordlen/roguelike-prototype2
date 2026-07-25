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
		primary_def = primary.get_defense()
		primary_range = primary.atk_range
	if offhand != null:
		offhand_atk = offhand.attack
		offhand_def = offhand.get_defense()
		offhand_range = offhand.atk_range

	var is_close: bool = max(\
		abs(actor.grid_position.x - actor.target_ch.grid_position.x),\
		abs(actor.grid_position.y - actor.target_ch.grid_position.y)) <= 1

	if (primary_atk + offhand_def < offhand_atk + primary_def and is_close) or offhand_range > primary_range:
		actor.deck.swap()
	
	# if reshuffle is necessary
	if ((actor.deck.primary == null or actor.deck.offhand == null) and primary_atk + offhand_atk == 0)\
	or (actor.is_cautious and len(actor.deck.discard_pile) >= 1 and\
	Pathfinder.chebychev_dist(actor.grid_position, actor.target_ch.grid_position) > 1) and\
	Globals.floor_map.get_tile(actor.grid_position) != RoomPattern.TileType.WATER:
		return [ReshuffleAction.new(actor)]

	# can see the target
	if actor.target_ch in actor.visible_actors:
		# request target flow map
		actor.hunt_with_team(actor.target_ch)
		
		# if both cards have 0 range and enemy can attack
		
		if actor.deck.primary.atk_range == 0 or (enemy_can_attack(actor, actor.target_ch) and offhand_is_decayed_enough(actor)):
			ret.push_back(DefendAction.new(actor))
		else:
			ret.push_back(AttackAction.new(actor, actor.target_ch))
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

func enemy_can_attack(actor: Char, enemy: Char) -> bool:
	if enemy.deck.primary == null:
		return false
	var target_max_range = enemy.deck.primary.atk_range
	if enemy.deck.offhand and enemy.deck.offhand.atk_range:
		target_max_range = max(target_max_range, enemy.deck.offhand.atk_range)
	return Pathfinder.chebychev_dist(actor.grid_position, enemy.grid_position) > target_max_range

func offhand_is_decayed_enough(actor: Char) -> bool:
	if actor.deck.offhand == null:
		return false
	return actor.deck.offhand.defense_decay * 2 > actor.deck.offhand.defense
