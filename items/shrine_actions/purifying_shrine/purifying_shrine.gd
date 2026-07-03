class_name PurifyingShrine1
extends ItemAction

func get_description() -> String:
	return "Permanently remove a card from your deck."

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 1, "Select 1 card to remove")
	var indices : Array[int] = await EventBus.cards_selected
	# now modify the card resource at that deck list
	var selected_card_resource := owner.deck.deck_list[indices[0]]
	owner.deck.remove_from_deck_list(selected_card_resource)
	EventBus.character_deck_updated.emit(owner)
	return true
