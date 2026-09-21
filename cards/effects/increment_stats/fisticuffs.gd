class_name Fisticuffs
extends CardEffect

func get_identifier() -> String:
	return "fisticuffs"
	
func get_description() -> String:
	return "Temporarily increase defense of the off-hand by the attack value of this card."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if actor.deck.offhand:
		var tmp_def_up := TmpDefUp.new()
		tmp_def_up.def_value = card.attack
		tmp_def_up.do(actor, target_pos, actor.deck.offhand)
	card_effect_finished.emit()
