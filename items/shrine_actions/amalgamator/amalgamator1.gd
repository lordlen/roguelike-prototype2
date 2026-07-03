class_name Amalgamator1
extends ItemAction

func get_description() -> String:
	return "Choose 2 cards to combine."

func use(owner: Char, pos: Vector2i) -> bool:
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 2, "Select 2 cards to combine")
	var indices : Array[int] = await EventBus.cards_selected
	var new_card := owner.deck.deck_list[indices[0]].combine(owner.deck.deck_list[indices[1]])
	# pop at the 2 indices
	indices.sort()
	indices.reverse()
	for ind in indices:
		owner.deck.deck_list.remove_at(ind)
	owner.deck.add_to_deck_list(new_card)
	owner.deck.initialize()
	return true
