class_name HealDefense
extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.take_damage(-card.defense)
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%d %s" % [card.defense, super.get_full_description(card)]
