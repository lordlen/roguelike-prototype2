class_name Explode
extends CardEffect

@export var value := 1

func get_identifier() -> String:
	return "explode"

func get_description() -> String:
	return "Deal n damage to ALL CHARACTERS adjacent to self."

func get_numeric() -> String:
	return "n"

func do(attacker: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var num_hits := 1
	var attack_val := value
	CardHelper.deal_aoe_damage(attack_val, num_hits, attacker, attacker.grid_position, 1, true)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
