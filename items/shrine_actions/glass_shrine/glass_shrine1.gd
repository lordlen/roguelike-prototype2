class_name GlassShrine1
extends ItemAction

func get_description() -> String:
	return 'Choose 1 card to double the attack and "Set the offhand defense to 0 until redraw."'

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	# get the owner's deck to pass into the card selector
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 1, "Select 1 card to modify")
	var indices : Array[int] = await EventBus.cards_selected
	# now modify the card resource at that deck list
	var selected_card_resource := owner.deck.deck_list[indices[0]]
	selected_card_resource.attack *= 2
	var card_effect : CardEffect = load("res://cards/effects/decay/offhand_full_decay.tres")
	selected_card_resource.attack_effects.push_back(card_effect)
	
	# reinitialize the deck
	owner.deck.initialize()
	EventBus.character_deck_updated.emit(owner)
	return true
