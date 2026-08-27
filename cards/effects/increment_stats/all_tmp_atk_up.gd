class_name AllTmpAtkUp
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "all_tmp_atk_up"
	
func get_description() -> String:
	return "Temporarily increase attack by n for all cards in the deck."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var tmp_atk_up := TmpAtkUp.new()
	tmp_atk_up.atk_value = atk_value
	for c in actor.deck.get_all_card_instances():
		tmp_atk_up.do(actor, target_char, c)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as AllTmpAtkUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
