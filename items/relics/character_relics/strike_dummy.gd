extends Relic

var atk_value := 3

func on_card_added(owner: Char, card: CardInstance):
	if card.card_name == "Strike":
		card.attack += atk_value

func on_self_pickup(owner: Char):
	for card in owner.deck.get_all_card_instances():
		if card.card_name == "Strike":
			card.attack += atk_value
