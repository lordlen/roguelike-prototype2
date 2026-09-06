class_name Riposte
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "riposte"
	
func get_description() -> String:
	return 'Move back 1 tile. The main-hand gains temporary n attack, 1 range, and "relocate"'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Relocate.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var atk_up := MainTmpAtkUp.new()
	atk_up.atk_value = value
	atk_up.do(actor, target_pos, card)
	var range_up := MainTmpRangeUp.new()
	range_up.value = 1
	range_up.is_temp = true
	range_up.do(actor, target_pos, card)
	var relocate := MainRelocate.new()
	relocate.is_temp = true
	relocate.do(actor, target_pos, card)
	var backslide := Backslide.new()
	backslide.is_temp = true
	backslide.do(actor, target_pos, card)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value = max(self.value, (other_effect as Riposte).value)
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
