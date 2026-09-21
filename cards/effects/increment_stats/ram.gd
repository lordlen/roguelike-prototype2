class_name Ram
extends CardEffect

func get_identifier() -> String:
	return "ram"
	
func get_description() -> String:
	return 'Increase attack by the off-hand defense.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var value := 0
	if actor.deck.offhand:
		value = actor.deck.offhand.defense
	var atk_up := TmpAtkUp.new()
	atk_up.atk_value = value
	atk_up.do(actor, target_pos, card)
	card_effect_finished.emit()
