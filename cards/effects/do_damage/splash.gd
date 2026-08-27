class_name Splash
extends CardEffect

@export var atk_value: int = 1
@export var radius: int = 1

func get_identifier() -> String:
	return "splash"

func get_description() -> String:
	return "Deal n damage to all enemies within radius m around the target."

func get_numeric() -> String:
	return "n m"

func do(attacker: Char, defender: Char, card: CardInstance) -> void:
	var atk_range := card.atk_range
	CardHelper.deal_aoe_damage(atk_value, 1, attacker, defender.grid_position, atk_range)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %d %s" % [atk_value, radius, super.get_shortform(card)]
