class_name PushAoe
extends CardEffect

@export var push_amount : int = 2

func get_identifier() -> String:
	return "push_aoe"
	
func get_description() -> String:
	return 'Push enemies within by n'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	CardHelper.push_aoe(actor.grid_position, actor.alignment, card.atk_range, push_amount)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [push_amount, super.get_shortform(card)]
