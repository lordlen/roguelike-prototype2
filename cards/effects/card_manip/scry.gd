class_name Scry
extends CardEffect

@export var num_cards: int

func get_identifier() -> String:
	return "scry"

func get_description() -> String:
	return "Pick 1 of n cards from the draw pile to put on top of the draw pile. Discard the rest."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_selections : int = min(len(actor.deck.draw_pile), num_cards)
	if num_selections > 1:
		var card_options: Array[CardInstance] = []
		for i in range(num_selections):
			# pull a random card from the deck
			var random_ind := randi_range(0, len(actor.deck.draw_pile) - 1)
			card_options.push_back(actor.deck.draw_pile.pop_at(random_ind))
		EventBus.card_selector_requested.emit(card_options, 1, "Select a card to draw.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var selected_card : CardInstance = card_options.pop_at(selected_ind)
		actor.deck.put_top(selected_card)
		
		# trigger discard effects
		for c in card_options:
			c.do_on_discard_effects(actor)
		actor.deck.append_to_discard(card_options)
	card_effect_finished.emit()


func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
