extends Relic

var atk_value := 1

func on_self_pickup(owner):
	# increase all card's attacks by 1
	for c in owner.deck.draw_pile:
		c.attack += atk_value
	
	for c in owner.deck.discard_pile:
		c.attack += atk_value
	
	if owner.deck.primary:
		owner.deck.primary.attack += atk_value
	
	if owner.deck.offhand:
		owner.deck.offhand.attack += atk_value
	
	# increase all card resources in the owner's deck by 1
	for card_resource in owner.deck.deck_list:
		card_resource.attack += atk_value

func on_card_added(owner: Char, card_resource: CardResource):
	card_resource.attack += atk_value
