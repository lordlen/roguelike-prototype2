class_name TurtleShrine3
extends ItemAction

func get_description() -> String:
	return "For this floor, add 4 defense for each card. On hit: Exhaust"

func use(owner: Char, pos: Vector2i) -> bool:
	owner.deck.discard_all()
	var discard_self : CardEffect = load("res://cards/effects/exhaust/self_exhaust_offhand.tres")
	for card in owner.deck.discard_pile:
		card.defense += 4
		card.on_hit_effects.push_back(discard_self)
	owner.deck.reshuffle()
	EventBus.character_deck_updated.emit(owner)
	return true
