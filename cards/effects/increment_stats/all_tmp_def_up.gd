class_name AllTmpDefUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "all_tmp_def_up"
	
func get_description() -> String:
	return "Temporarily increase defense by n for all cards in the deck."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var tmp_def_up := TmpDefUp.new()
	tmp_def_up.def_value = value
	for c in actor.deck.get_all_card_instances():
		tmp_def_up.do(actor, target_pos, c)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as AllTmpDefUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
