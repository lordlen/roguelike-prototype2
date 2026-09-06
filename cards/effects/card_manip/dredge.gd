class_name Dredge
extends CardEffect

func get_identifier() -> String:
	return "dredge"

func get_description() -> String:
	return "Pick a card from the discard pile and put it on top of the draw pile."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if len(actor.deck.discard_pile) > 0:
		EventBus.card_selector_requested.emit(actor.deck.discard_pile, 1, "Select a card to put on the draw pile.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var selected_card : CardInstance = actor.deck.discard_pile.pop_at(selected_ind)
		actor.deck.put_top(selected_card)
	card_effect_finished.emit()
