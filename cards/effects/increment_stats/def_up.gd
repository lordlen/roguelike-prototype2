class_name DefUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "def_up"
	
func get_description() -> String:
	return "Increase defense of this card by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	card.defense += value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as DefUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
