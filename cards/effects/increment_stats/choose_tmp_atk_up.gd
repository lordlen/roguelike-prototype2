class_name ChooseAtkUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "foresight"

func get_description() -> String:
	return "Add n attack temporarily to the top card in the draw pile."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if len(actor.deck.draw_pile) > 0:
		var tmp_atk_up := TmpAtkUp.new()
		tmp_atk_up.atk_value = value
		tmp_atk_up.do(actor, target_pos, actor.deck.draw_pile[-1])
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
