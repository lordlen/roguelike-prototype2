class_name SimplicityShrine2
extends ItemAction

func get_description() -> String:
	return "Permanently -3 attack for all strikes. +2 defense for all defends"

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	
	for card_resource in owner.deck.deck_list:
		if card_resource.name == "Strike":
			card_resource.attack -= 3
		elif card_resource.name == "Defend":
			card_resource.defense += 2
	
	owner.deck.initialize()
	EventBus.character_deck_updated.emit(owner)
	return true
