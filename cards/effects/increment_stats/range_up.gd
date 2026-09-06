class_name RangeUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "range_up"
	
func get_description() -> String:
	return "Increase the range of this card by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	card.atk_range += value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as RangeUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
