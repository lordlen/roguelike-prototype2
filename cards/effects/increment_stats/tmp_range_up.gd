class_name TmpRangeUp
extends CardEffect

@export var value: int
@export var stacks: bool = true

func get_identifier() -> String:
	return "tmp_range_up"
	
func get_description() -> String:
	return "Temporarily increase attack range of this card by n"

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	card.atk_range += value
	var range_down := RangeUp.new()
	range_down.value = -value
	range_down.is_temp = true
	CardEffect.combine_effects(card.on_use_effects, [range_down])
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !stacks:
		return self
	if self.is_same_effect(other_effect):
		self.value += (other_effect as TmpRangeUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
