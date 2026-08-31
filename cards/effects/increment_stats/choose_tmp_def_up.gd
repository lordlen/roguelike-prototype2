class_name ChooseDefUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "prepare"

func get_description() -> String:
	return "Add n defense temporarily to the top card in the draw pile."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if len(actor.deck.draw_pile) > 0:
		var tmp_def_up := TmpDefUp.new()
		tmp_def_up.def_value = value
		tmp_def_up.do(actor, target_char, actor.deck.draw_pile[-1])
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
