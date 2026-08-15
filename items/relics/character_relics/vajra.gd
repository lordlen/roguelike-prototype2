extends Relic

var atk_value := 1

func on_card_added(owner: Char, card: CardInstance):
	card.attack += atk_value
