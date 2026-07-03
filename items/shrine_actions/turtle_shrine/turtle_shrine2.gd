class_name TurtleShrine2
extends ItemAction

func get_description() -> String:
	return "Choose 1 card to increase defense by 2. Lose a potion."

func use(owner: Char, pos: Vector2i) -> bool:
	if owner.inventory.items.is_empty():
		return true
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 1, "Select 1 card to increase defense")
	var indices : Array[int] = await EventBus.cards_selected
	# remove random potion
	var rand_ind := randi_range(0, len(owner.inventory.items))
	owner.inventory.remove_at(rand_ind)
	owner.deck.deck_list[indices[0]].defense += 2
	owner.deck.initialize()
	EventBus.character_deck_updated.emit(owner)
	return true

func is_usable(owner: Char):
	if owner.inventory.items.is_empty():
		return false
	return true
