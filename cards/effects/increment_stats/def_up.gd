class_name DefUp
extends CardEffect

@export var value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card.defense += value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as AtkUp).atk_value
	return self

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
