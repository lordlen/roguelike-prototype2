extends Relic

func on_next_floor(owner):
	# add a new card reward somewhere randomly
	var ground_positions := Globals.floor_map.get_type_positions([TileResource.Terrains.GROUND])
	var card_item := load("res://items/card_item/card_reward_item.tres")
	var random_position : Vector2i= ground_positions.pick_random()
	ItemManager.add_item_to_overworld(card_item, random_position)
