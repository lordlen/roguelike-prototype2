class_name BloodyShrine1
extends ItemAction

func get_description() -> String:
	return 'Choose 1 card to add 5 atk 4 def and "lose 2 hp" on attack and defend.'

func use(owner: Char, pos: Vector2i) -> bool:
	if !super.use(owner, pos):
		return false

	# get the owner's deck to pass into the card selector
	var card_list : Array[CardInstance] = []
	for card_resource in owner.deck.deck_list:
		var card_instance := CardInstance.new(card_resource)
		card_list.push_back(card_instance)
	EventBus.card_selector_requested.emit(card_list, 1, "Select 1 card to add the bloody modifier")
	var indices : Array[int] = await EventBus.cards_selected
	# now modify the card resource at that deck list
	var selected_card_resource := owner.deck.deck_list[indices[0]]
	selected_card_resource.attack += 5
	selected_card_resource.defense += 4
	# add "lose 2 hp"
	var lose_hp_effect : CardEffect = LoseHp.new()
	lose_hp_effect.value = 2
	# add this effect to both defense and attack
	selected_card_resource.attack_effects.push_back(lose_hp_effect)
	selected_card_resource.defense_effects.push_back(lose_hp_effect)
	
	# reinitialize the deck
	owner.deck.initialize()
	EventBus.character_deck_updated.emit(owner)
	return true
