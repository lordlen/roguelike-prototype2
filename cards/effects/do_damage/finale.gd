class_name DamageFinale
extends CardEffect

func get_identifier() -> String:
	return "damage_finale"

func get_description() -> String:
	return "Deal n damage as many times as cards in the discard pile."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_hits := card.num_hits + len(actor.deck.discard_pile)
	var attack_val := card.attack
	await CardHelper.deal_damage(attack_val, num_hits, actor, target_char)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
