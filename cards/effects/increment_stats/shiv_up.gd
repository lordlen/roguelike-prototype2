class_name ShivUp
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "shiv_up"
	
func get_description() -> String:
	return "Increase attack of all shivs by n"

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	for c in actor.deck.get_all_card_instances():
		if c.card_name == "Shiv":
			c.attack += atk_value
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as ShivUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
