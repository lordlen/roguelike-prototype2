class_name GlassShrine2
extends ItemAction

func get_description() -> String:
	return "For this floor, double attack and 0 defense for all cards."

func use(owner: Char, pos: Vector2i) -> bool:
	owner.deck.discard_all()
	var discard_self : CardEffect = load("res://cards/effects/exhaust/self_exhaust_offhand.tres")
	for card in owner.deck.discard_pile:
		card.attack *= 2
		card.defense = 0
	owner.deck.reshuffle()
	EventBus.character_deck_updated.emit(owner)
	return true
