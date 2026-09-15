class_name CardHelper

#destroy grass around target and return the number of grass
static func mow_grass(pos: Vector2i) -> int:
	var trampled_grass := load("res://floor_generator/tiles/trampled_grass.tres")
	# get the adjacent tiles
	var adjacent_tiles := DijkstraMap._get_adjacent_edges(pos)
	var grass_count := 0
	for cell in adjacent_tiles + [pos]:
		if Globals.floor_map.get_tile(cell).terrain_id == 2:
			Globals.floor_map.update_tile(cell, trampled_grass)
			grass_count += 1
	return grass_count

static func drain_water(pos: Vector2i) -> int:
	var ground_tile_resource := load("res://floor_generator/tiles/ground.tres")
	# get the adjacent tiles
	var adjacent_tiles := DijkstraMap._get_adjacent_edges(pos)
	var water_count := 0
	for cell in adjacent_tiles + [pos]:
		if Globals.floor_map.get_tile(cell).terrain_id == 3:
			Globals.floor_map.update_tile(cell, ground_tile_resource)
			water_count += 1
	return water_count

static func deal_damage(attack_val: int, num_hits, actor: Char, target_char: Char):
	for _i in num_hits:
		if !is_instance_valid(target_char) or target_char.is_dead():
			break
		actor.attack_animation.call_deferred(target_char.grid_position)
		await target_char.take_hit(actor, attack_val)
		await actor.char_finished_attacking

static func deal_aoe_damage(attack_val: int, num_hits: int, attacker: Char, target_pos: Vector2i, atk_range: int, friendly_fire := false):
	for x in range(target_pos.x - atk_range, target_pos.x + atk_range + 1):
		for y in range(target_pos.y - atk_range, target_pos.y + atk_range + 1):
			var pos := Vector2i(x,y)
			var char := ActorManager.get_actor_in_position(pos)
			if char == null or (!friendly_fire and char.alignment == attacker.alignment):
				continue
			
			for _i in num_hits:
				if !is_instance_valid(char) or char.is_dead():
					break
				char.take_hit(attacker, attack_val)

static func generate_terrain(pos: Vector2i, tile_type: TileResource, replaceable: Array[TileResource.Terrains], num_gen: int, radius: int):
	var adj_tiles := Globals.floor_map.get_area(pos, radius)
	var valid_tiles := Globals.floor_map.get_type_positions_in_area(replaceable, adj_tiles)
	valid_tiles.shuffle()
	for i in range(min(num_gen, len(valid_tiles))):
		Globals.floor_map.update_tile(valid_tiles[i], tile_type)

static func push_target(target: Char, from: Vector2i, push_amount):
	if is_instance_valid(target):
		var line_iterator:= BresenhamIterator.new(from, target.grid_position, push_amount)
		var curr_pos := target.grid_position
		for pos in line_iterator:
			# check if position is occupied by a wall or char
			if ActorManager.get_actor_in_position(pos) != null\
			or Globals.floor_map.get_tile(pos).get_pf_cost(target.traversal) == INF:
				break
			curr_pos = pos
		target.move_to(curr_pos)

static func push_aoe(from: Vector2i, user_alignment: Char.Alignment, radius: int, push_amount: int):
	var position := Globals.floor_map.get_area(from, radius)
	var chars := ActorManager.get_actors_in_positions(position)
	for char in chars:
		if char.alignment != user_alignment:
			# push the target back x amount of tiles.
			var line_iterator:= BresenhamIterator.new(from, char.grid_position, push_amount)
			var curr_pos := char.grid_position
			for pos in line_iterator:
				# check if position is occupied by a wall or char
				if ActorManager.get_actor_in_position(pos) != null\
				or Globals.floor_map.get_tile(pos).get_pf_cost(char.traversal) == INF:
					break
				
				curr_pos = pos
			char.move_to(curr_pos)

static func scry(actor: Char, num_cards: int):
	if actor.user_controlled:
		var num_selections : int = min(len(actor.deck.draw_pile), num_cards)
		if num_selections > 0:
			var card_options: Array[CardInstance] = actor.deck.draw_pile.slice(-num_cards, len(actor.deck.draw_pile))
			card_options.reverse()
			EventBus.card_selector_requested.emit(card_options, 0, "Select cards to discard.")
			var indices : Array[int] = await EventBus.cards_selected
			# card options is reversed, so
			var original_length := len(actor.deck.draw_pile)
			for relative_ind in indices:
				# pop at
				var ind := original_length - 1 - relative_ind
				var c : CardInstance = actor.deck.discard_at(ind)
				await c.do_on_discard_effects(actor)

static func seek(actor: Char, num_cards: int):
	if actor.user_controlled:
		var num_selections : int = min(len(actor.deck.draw_pile), num_cards)
		if num_selections > 1:
			var card_options: Array[CardInstance] = []
			var all_ind := range(len(actor.deck.draw_pile))
			all_ind.shuffle()
			var selection_inds := all_ind.slice(0, num_selections)
			for i in selection_inds:
				card_options.push_back(actor.deck.draw_pile[i])
			EventBus.card_selector_requested.emit(card_options, 1, "Select a card to draw.")
			var indices : Array[int] = await EventBus.cards_selected
			var selected_ind := indices[0]
			var actual_ind : int = selection_inds[selected_ind]
			var selected_card := actor.deck.pop_at(actual_ind)
			actor.deck.put_top(selected_card)
