extends Relic

func on_card_added(owner: Char, card: CardInstance):
	if card.card_name == "Cast Spell":
		card.defense += 6

func on_self_pickup(owner: Char):
	for card in owner.deck.get_all_card_instances():
		if card.card_name == "Cast Spell":
			card.defense += 6
