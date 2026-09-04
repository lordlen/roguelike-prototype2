class_name Feed
extends CardEffect

@export var value: int = 1

func get_identifier() -> String:
	return "feed"
	
func get_description() -> String:
	return "If the target is dead, heal n hp."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if !is_instance_valid(target_char) or target_char.is_dead():
		actor.take_damage(-value)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Feed).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
