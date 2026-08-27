class_name Infect
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "infect"
	
func get_description() -> String:
	return 'Apply n poison if the target is not blocking.'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Poison.new()]

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if !target_char.is_defending:
		var poison := Poison.new()
		poison.value = value
		poison.do(actor, target_char, card)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Poison).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
