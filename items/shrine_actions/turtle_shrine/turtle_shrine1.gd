class_name TurtleShrine1
extends ItemAction

func get_description() -> String:
	return "+1 defense and -1 attack to all cards in the deck"

func use(owner: Char, pos: Vector2i) -> bool:
	for card_resource in owner.deck.deck_list:
		card_resource.attack = max(0, card_resource.attack - 1)
		card_resource.defense += 1
	owner.deck.initialize()
	EventBus.character_deck_updated.emit(owner)
	return true
