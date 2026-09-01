class_name GainGold
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "gold"
	
func get_description() -> String:
	return "Gain n gold."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.inventory.add_gold(value)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as GainGold).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
