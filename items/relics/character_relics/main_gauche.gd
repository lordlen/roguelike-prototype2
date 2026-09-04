extends Relic

func on_defend(actor: Char):
	if actor.deck.offhand:
		actor.deck.offhand.add_bonus_defense(3)
