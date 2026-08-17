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
		actor.attack_animation.call_deferred(target_char.grid_position)
		await actor.char_finished_attacking
		await target_char.take_hit(actor, attack_val)
		if target_char.is_dead():
			break

static func deal_aoe_damage(attack_val: int, num_hits: int, attacker: Char, target_pos: Vector2i, atk_range: int):
	for x in range(target_pos.x - atk_range, target_pos.x + atk_range + 1):
		for y in range(target_pos.y - atk_range, target_pos.y + atk_range + 1):
			var pos := Vector2i(x,y)
			var char := ActorManager.get_actor_in_position(pos)
			if char == null or char.alignment == attacker.alignment:
				continue
			
			for _i in num_hits:
				char.take_hit(attacker, attack_val)
				if char.is_dead():
					break
