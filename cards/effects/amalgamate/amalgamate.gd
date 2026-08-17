class_name Amalgamate
extends CardEffect

func get_identifier() -> String:
	return "amalgamate"

func get_description() -> String:
	return "Combine this card with the offhand."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# take the offhand instance and combine the stats
	# add the stats of the other card
	if actor.deck.offhand == null:
		card_effect_finished.emit()
		return
	
	var other_card := actor.deck.offhand
	card.attack += other_card.attack
	card.defense += other_card.defense
	# take the maximum of number of hits rather than adding
	card.num_hits = max(card.num_hits, other_card.num_hits)
	card.atk_range = max(card.atk_range, other_card.atk_range)
	
	# only keep dodge if both are dodge
	card.is_dodge = card.is_dodge and other_card.is_dodge
	card.exhausts = card.exhausts or other_card.exhausts
	card.is_innate = card.is_innate or other_card.is_innate
	card.is_ethereal = card.is_ethereal or other_card.is_ethereal
	
	# now effects need to be added to each other
	card.attack_effects = CardEffect.combine_effects(card.attack_effects, other_card.attack_effects)
	card.defense_effects = CardEffect.combine_effects(card.defense_effects, other_card.defense_effects)
	card.on_hit_effects = CardEffect.combine_effects(card.on_hit_effects, other_card.on_hit_effects)

	# exhaust offhand
	actor.deck.exhaust_offhand()
	card_effect_finished.emit()
