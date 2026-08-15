extends Relic

var value := 1

func on_card_added(owner: Char, card: CardInstance):
	card.defense += value
