class_name AtkUp
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "atk_up"
	
func get_description() -> String:
	return "Increase the attack of this card by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if is_instance_valid(actor):
		card.attack += atk_value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as AtkUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
