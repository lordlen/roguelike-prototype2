class_name MainTmpAtkUp
extends CardEffect

@export var atk_value: int
@export var target: Target

func get_identifier() -> String:
	return "main_tmp_atk_up" if target == Target.ENEMY else "self-main_tmp_atk_up"
	
func get_description() -> String:
	return "Temporarily increase main hand attack by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	if t.deck.primary:
		var tmp_atk_up := TmpAtkUp.new()
		tmp_atk_up.atk_value = atk_value
		tmp_atk_up.do(actor, target_char, t.deck.primary)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as MainTmpAtkUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
