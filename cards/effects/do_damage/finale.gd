extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits + len(actor.deck.discard_pile)
	var attack_val := card.attack
	for _i in num_hits:
		actor.attack_animation.call_deferred(target_char.grid_position)
		await actor.char_finished_attacking
		await target_char.take_hit(actor, attack_val)
		if target_char.is_dead():
			break
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
