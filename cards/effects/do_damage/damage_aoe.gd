extends CardEffect

func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	for x in range(attacker.grid_position.x - card.atk_range, attacker.grid_position.x + card.atk_range + 1):
		for y in range(attacker.grid_position.y - card.atk_range, attacker.grid_position.y + card.atk_range + 1):
			var pos := Vector2i(x,y)
			var char := ActorManager.get_actor_in_position(pos)
			if char == null or char.alignment == attacker.alignment:
				continue
			
			var num_hits := card.num_hits
			var attack_val := card.attack
			for _i in num_hits:
				char.take_hit(attacker, attack_val)
	card_effect_finished.emit()
