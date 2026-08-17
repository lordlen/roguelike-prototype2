class_name FixedBonusDefense
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "bonus_defense"

func get_description() -> String:
	return "Gain n bonus defense this turn."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if actor.deck.offhand:
		actor.deck.offhand.bonus_defense += value
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
