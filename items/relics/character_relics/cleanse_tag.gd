extends Relic

func on_self_pickup(owner: Char):
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 1, "Select 1 card to remove")
	var indices : Array[int] = await EventBus.cards_selected
	owner.deck.deck_list.remove_at(indices[0])
	owner.deck.initialize()
	
