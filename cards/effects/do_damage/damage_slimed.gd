extends CardEffect

var slime_scaling := 2

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# count how many slimes are in the deck
	var target_cards := target_char.deck.get_all_card_instances()
	# count slimes
	var num_slimed := 0
	for c in target_cards:
		if c.card_name == "Slimed":
			num_slimed += 1

	var num_hits := card.num_hits
	var attack_val := card.attack + (slime_scaling * num_slimed)
	await CardHelper.deal_damage(attack_val, num_hits, actor, target_char)
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %d %s" % [card.get_attack(), slime_scaling, super.get_shortform(card)]
