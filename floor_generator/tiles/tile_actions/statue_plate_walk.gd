class_name StatuePlateWalk
extends ItemAction

func use(owner: Char, pos: Vector2i) -> bool:
	if owner.user_controlled:
		var ground := load("res://floor_generator/tiles/ground.tres")
		for x in range(pos.x - effect_radius, pos.x + effect_radius + 1):
			for y in range(pos.y - effect_radius, pos.y + effect_radius + 1):
				# reveal statue
				var cell := Vector2i(x, y)
				var tile := Globals.floor_map.get_tile(cell)
				if tile.terrain_id == TileResource.Terrains.STATUE:
					Globals.floor_map.update_tile(cell, ground)
					if tile.hidden_char != null:
						var char := Char.new(tile.hidden_char, cell)
						char.wander()
	return true
