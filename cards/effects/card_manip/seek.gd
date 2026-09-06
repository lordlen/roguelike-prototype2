class_name Seek
extends CardEffect

@export var num_cards: int

func get_identifier() -> String:
	return "seek"

func get_description() -> String:
	return "Pick 1 of n cards from the draw pile to put on top of the draw pile."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var num_selections : int = min(len(actor.deck.draw_pile), num_cards)
	if num_selections > 1:
		var card_options: Array[CardInstance] = []
		var all_ind := range(len(actor.deck.draw_pile))
		all_ind.shuffle()
		var selection_inds := all_ind.slice(0, num_selections)
		for i in selection_inds:
			card_options.push_back(actor.deck.draw_pile[i])
		EventBus.card_selector_requested.emit(card_options, 1, "Select a card to draw.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var actual_ind : int = selection_inds[selected_ind]
		var selected_card := actor.deck.pop_at(actual_ind)
		actor.deck.put_top(selected_card)
	card_effect_finished.emit()


func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
