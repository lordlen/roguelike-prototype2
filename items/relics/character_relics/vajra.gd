extends Relic

var atk_value := 1

func on_card_added(owner: Char, card: CardInstance):
	card.attack += atk_value

func on_self_pickup(owner: Char):
	for card in owner.deck.get_all_card_instances():
		card.attack += atk_value
