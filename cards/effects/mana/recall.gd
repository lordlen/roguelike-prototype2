extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# find in discard
	var cs = actor.deck.pop_card("Cast Spell")
	if cs != null:
		actor.deck.add_to_top_draw(cs)
	card_effect_finished.emit()
