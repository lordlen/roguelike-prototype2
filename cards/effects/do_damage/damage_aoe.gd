class_name DamageAoe
extends CardEffect

func get_identifier() -> String:
	return "damage_AOE"

func get_description() -> String:
	return "Deal n damage to all enemies in range."

func get_numeric() -> String:
	return "n"

func do(attacker: Char, defender: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack
	var atk_range := card.atk_range
	CardHelper.deal_aoe_damage(attack_val, num_hits, attacker, attacker.grid_position, atk_range)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
