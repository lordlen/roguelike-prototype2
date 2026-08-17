class_name HealDefense
extends CardEffect

func get_identifier() -> String:
	return "heal_def"
	
func get_description() -> String:
	return "Heal for how much defense this card has."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.take_damage(-card.defense)
	card_effect_finished.emit()
