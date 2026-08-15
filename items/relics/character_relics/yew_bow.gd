extends Relic

func on_self_pickup(owner: Char):
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 1, "Select 1 card to increase range.")
	var indices : Array[int] = await EventBus.cards_selected
	var selected_card_resource := owner.deck.deck_list[indices[0]]
	selected_card_resource.range += 1
	owner.deck.initialize()
