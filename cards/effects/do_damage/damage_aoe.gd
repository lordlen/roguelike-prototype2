extends CardEffect

func do(attacker: Char, defender: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack
	var atk_range := card.atk_range
	CardHelper.deal_aoe_damage(attack_val, num_hits, attacker, attacker.grid_position, atk_range)
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
