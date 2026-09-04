class_name OffhandAttack
extends CardEffect

func get_identifier() -> String:
	return "offhand_attack"

func get_description() -> String:
	return "Attack target with the defense."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var offhand := actor.deck.offhand
	
	if offhand == null:
		card_effect_finished.emit()
		return
	
	offhand.do_attack.call_deferred(actor, target_char)
	await offhand.card_action_finished
	actor.deck.discard_offhand()
	card_effect_finished.emit()
