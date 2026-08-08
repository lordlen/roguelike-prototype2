class_name LoseHp
extends CardEffect

@export var value: int
func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.take_damage(value)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as LoseHp).value
	return self

func get_full_description(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
