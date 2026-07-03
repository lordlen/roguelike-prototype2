class_name Amalgamator2
extends ItemAction

func get_description() -> String:
	return 'Add "Amalgamate" to your deck.'

func use(owner: Char, pos: Vector2i) -> bool:
	var amalgamate : CardResource = load("res://cards/card_resources/special/amalgamate.tres")
	owner.deck.add_to_deck_list(amalgamate)
	EventBus.character_deck_updated.emit(owner)
	return true
