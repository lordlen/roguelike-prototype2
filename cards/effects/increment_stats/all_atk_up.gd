class_name AllAtkUp
extends CardEffect

@export var atk_value: int
@export var target: Target

func get_identifier() -> String:
	return "all_atk_up" if target == Target.ENEMY else "self-all_atk_up"
	
func get_description() -> String:
	return "Increase attack by n for all cards in the deck."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else target_char
	var atk_up := AtkUp.new()
	atk_up.atk_value = atk_value
	for c in t.deck.get_all_card_instances():
		atk_up.do(t, target_char, c)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as AllTmpAtkUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
