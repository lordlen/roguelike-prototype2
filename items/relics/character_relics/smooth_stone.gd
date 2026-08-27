extends Relic

var value := 1

func on_card_added(owner: Char, card: CardInstance):
	card.defense += value

func on_self_pickup(owner: Char):
	for card in owner.deck.get_all_card_instances():
		card.defense += value
