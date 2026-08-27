class_name HitsUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "hits_up"
	
func get_description() -> String:
	return "Increase the number of hits of this card by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card.num_hits += value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as HitsUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
