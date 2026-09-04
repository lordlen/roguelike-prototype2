class_name DoDamage
extends CardEffect

@export var bonus_damage: int

func get_identifier() -> String:
	return "damage"

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits
	var attack_val := card.attack + bonus_damage
	await CardHelper.deal_damage(attack_val, num_hits, actor, target_char)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
