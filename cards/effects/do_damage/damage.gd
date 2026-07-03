extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack
	for _i in num_hits:
		actor.attack_animation.call_deferred(target_char.grid_position)
		await actor.char_finished_attacking
		await target_char.take_hit(actor, attack_val)
	card_effect_finished.emit()
