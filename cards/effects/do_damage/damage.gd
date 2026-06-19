extends CardEffect

func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack
	for _i in num_hits:
		defender.take_hit(attacker, attack_val)
