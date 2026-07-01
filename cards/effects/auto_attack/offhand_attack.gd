extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var offhand := actor.deck.offhand
	
	if offhand == null:
		return
	
	offhand.do_attack.call_deferred(actor, target_char, path)
	await offhand.card_action_finished
	actor.deck.discard_offhand()
	card_effect_finished.emit()
