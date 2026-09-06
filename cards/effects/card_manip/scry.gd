class_name Scry
extends CardEffect

@export var num_cards: int

func get_identifier() -> String:
	return "scry"

func get_description() -> String:
	return "Look at the top n cards in the draw pile and select cards to discard."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var num_selections : int = min(len(actor.deck.draw_pile), num_cards)
	if num_selections > 0:
		var card_options: Array[CardInstance] = actor.deck.draw_pile.slice(-num_cards, len(actor.deck.draw_pile))
		card_options.reverse()
		EventBus.card_selector_requested.emit(card_options, 0, "Select cards to discard.")
		var indices : Array[int] = await EventBus.cards_selected
		# card options is reversed, so
		var original_length := len(actor.deck.draw_pile)
		for relative_ind in indices:
			# pop at
			var ind := original_length - 1 - relative_ind
			var c : CardInstance = actor.deck.discard_at(ind)
			await c.do_on_discard_effects(actor)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
