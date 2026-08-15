extends Relic
var value := 2
var counter := 0
func on_attack(actor: Char, defender: Char):
	counter += 1
	if counter >= 3:
		actor.deck.offhand.add_bonus_defense(value)
		counter = 0
		
