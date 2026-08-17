class_name TmpAtkUp
extends CardEffect

@export var atk_value: int
@export var stacks: bool = true

func get_identifier() -> String:
	return "tmp_atk_up"
	
func get_description() -> String:
	return "Temporarily increase attack of this card by n"

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card.attack += atk_value
	var atk_down := AtkUp.new()
	atk_down.atk_value = -atk_value
	atk_down.is_temp = true
	CardEffect.combine_effects(card.attack_effects, [atk_down])
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !stacks:
		return self
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as AtkUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
