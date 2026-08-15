extends Relic

var atk_value := 3

func on_card_added(owner: Char, card: CardInstance):
	if card.card_name == "Strike":
		card.attack += atk_value
