extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits
	var attack_val := actor.curr_hp
	for _i in num_hits:
		target_char.take_hit(actor, attack_val)
	card_effect_finished.emit()
