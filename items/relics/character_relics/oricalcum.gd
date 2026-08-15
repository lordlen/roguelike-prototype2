extends Relic
var value := 3
func on_reshuffle(actor: Char):
	if actor.deck.offhand:
		actor.deck.offhand.add_bonus_defense(value)
