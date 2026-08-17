class_name DamageFixed
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "patience"

func get_description() -> String:
	return "Deal n damage (ignores defense)."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	for i in range(card.num_hits):
		target_char.take_damage(atk_value)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
