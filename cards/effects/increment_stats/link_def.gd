class_name LinkDef
extends CardEffect

func get_identifier() -> String:
	return "link_def"

func get_description() -> String:
	return "Pick a card from the draw pile. Discard it and add its defense to this card"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if len(actor.deck.draw_pile) > 0:
		var draw_pile := actor.deck.draw_pile.duplicate()
		draw_pile.sort_custom(func (a,b): return a.card_name < b.card_name)
		EventBus.card_selector_requested.emit(draw_pile, 1, "Select a card to link defense.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var selected_card : CardInstance = draw_pile[selected_ind]
		var tmp_def_up := TmpDefUp.new()
		tmp_def_up.def_value = selected_card.defense
		tmp_def_up.do(actor, target_char, card)
		actor.deck.draw_pile.erase(selected_card)
		await selected_card.do_on_discard_effects(actor)
		actor.deck.add_to_discard(selected_card)
	card_effect_finished.emit()
