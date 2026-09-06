class_name Deduce
extends CardEffect

func get_identifier() -> String:
	return "deduce"

func get_description() -> String:
	return "Pick a card from the draw pile. Discard it."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if len(actor.deck.draw_pile) > 0:
		var draw_pile := actor.deck.draw_pile.duplicate()
		draw_pile.sort_custom(func (a,b): return a.card_name < b.card_name)
		EventBus.card_selector_requested.emit(draw_pile, 1, "Select a card to discard.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var selected_card : CardInstance = draw_pile[selected_ind]
		actor.deck.draw_pile.erase(selected_card)
		await selected_card.do_on_discard_effects(actor)
		actor.deck.add_to_discard(selected_card)
	card_effect_finished.emit()
