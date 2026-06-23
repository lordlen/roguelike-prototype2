extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack
	for _i in num_hits:
		target_char.take_hit(actor, attack_val)
