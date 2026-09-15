class_name Reduce
extends CardEffect

func get_identifier() -> String:
	return "reduce"

func get_description() -> String:
	return "Pick a card from the draw pile. Exhaust it."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if len(actor.deck.draw_pile) > 0:
		var draw_pile := actor.deck.draw_pile.duplicate()
		draw_pile.sort_custom(func (a,b): return a.card_name < b.card_name)
		EventBus.card_selector_requested.emit(draw_pile, 1, "Select a card to exhaust.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var selected_card : CardInstance = draw_pile[selected_ind]
		actor.deck.draw_pile.erase(selected_card)
	card_effect_finished.emit()
