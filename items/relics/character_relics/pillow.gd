extends Relic

@export var atk_up_effect: CardEffect
func on_wait(owner: Char):
	var offense := owner.deck.primary
	if offense:
		CardEffect.combine_effects(offense.attack_effects, [atk_up_effect])
