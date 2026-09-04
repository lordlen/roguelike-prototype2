extends Relic

func on_walk_effect(actor: Char):
	if actor.deck.offhand:
		actor.deck.offhand.add_bonus_defense(3)
