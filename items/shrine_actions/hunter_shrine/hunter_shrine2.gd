class_name HunterShrine2
extends ItemAction

func get_description() -> String:
	return "For this floor, all cards +1 range."

func use(owner: Char, pos: Vector2i) -> bool:
	owner.deck.discard_all()
	for card in owner.deck.discard_pile:
		card.atk_range += 1
	owner.deck.reshuffle()
	EventBus.character_deck_updated.emit(owner)
	return true
