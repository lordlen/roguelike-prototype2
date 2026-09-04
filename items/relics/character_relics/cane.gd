extends Relic

func on_card_added(owner: Char, card: CardInstance):
	var effect := OffTmpDefUp.new()
	effect.def_value += 3
	CardEffect.combine_effects(card.on_discard_effects, [effect])

func on_self_pickup(owner: Char):
	for card in owner.deck.get_all_card_instances():
		var effect := OffTmpDefUp.new()
		effect.def_value += 3
		CardEffect.combine_effects(card.on_discard_effects, [effect])
