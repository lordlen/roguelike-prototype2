class_name HuntingState
extends AiState

func get_state_name() -> String:
	return "Hunting"

func should_swap(actor: Char) -> bool:
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

	#var is_close: bool = max(\
		#abs(actor.grid_position.x - actor.target_ch.grid_position.x),\
		#abs(actor.grid_position.y - actor.target_ch.grid_position.y)) <= 1

	return (primary_atk + offhand_def < offhand_atk + primary_def)

func should_reshuffle(actor: Char):
	var primary_atk = 0 if actor.deck.primary == null else actor.deck.primary.attack
	var offhand_atk = 0 if actor.deck.offhand == null else actor.deck.offhand.attack
	return ((actor.deck.primary == null or actor.deck.offhand == null) and primary_atk + offhand_atk == 0)\
	or (actor.is_cautious and len(actor.deck.discard_pile) >= 1 and\
	Pathfinder.chebychev_dist(actor.grid_position, actor.target_ch.grid_position) > 1) and\
	Globals.floor_map.get_tile(actor.grid_position).terrain_id != 3

func act(actor: Char) -> Array[Action]:
	# if the prey is dead, change prey or swap to wander
	if !is_instance_valid(actor.target_ch):
		# TODO: switch target if necessary
		actor.wander()
		return actor.curr_state.act(actor)

	var ret : Array[Action] = []

	if should_swap(actor):
		actor.deck.swap()
	
	# if reshuffle is necessary
	if should_reshuffle(actor):
		return [ReshuffleAction.new(actor)]

	# can see the target
	if actor.target_ch in actor.visible_actors:
		# request target flow map
		actor.hunt_with_team(actor.target_ch)
		
		ret.push_back(AttackAction.new(actor, actor.target_ch))
	else:
		if actor.target_flow_map.destination_reached(actor.grid_position) or !actor.moved_last_turn:
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

func can_reach(actor: Char, target: Char, atk_range: int) -> bool:
	return Pathfinder.chebychev_dist(actor.grid_position, target.grid_position) <= atk_range 

func off_can_reach(actor: Char, target: Char) -> bool:
	var main_atk_range := 0
	if actor.deck.primary:
		main_atk_range = actor.deck.primary.atk_range
	var off_atk_range := 0
	if actor.deck.offhand:
		off_atk_range = actor.deck.offhand.atk_range
	return can_reach(actor, target, off_atk_range)\
	and !can_reach(actor, target, main_atk_range)
