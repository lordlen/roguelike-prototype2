class_name HealAttack
extends CardEffect

func get_identifier() -> String:
	return "heal_atk"
	
func get_description() -> String:
	return "Heal for how much attack this card has."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.take_damage(-card.attack)
	card_effect_finished.emit()
