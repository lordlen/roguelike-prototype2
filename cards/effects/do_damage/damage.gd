extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack
	await CardHelper.deal_damage(attack_val, num_hits, actor, target_char)
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
