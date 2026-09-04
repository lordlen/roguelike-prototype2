extends Relic

func on_self_pickup(owner: Char):
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 2, "Select 2 cards to increase defense by 3.")
	var indices : Array[int] = await EventBus.cards_selected
	for index in indices:
		var selected_card_resource := owner.deck.deck_list[index]
		selected_card_resource.defense += 3
	owner.deck.initialize()
