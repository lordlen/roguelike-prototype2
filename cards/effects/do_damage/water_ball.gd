class_name DamageWaterball
extends CardEffect

func get_identifier() -> String:
	return "damage_waterball"

func get_description() -> String:
	return "Drain adjacent water tiles. Deal n damage as many times as water drained."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var target_char := ActorManager.get_actor_in_position(target_pos)
	var water_drained := CardHelper.drain_water(actor.grid_position)
	var num_hits := card.num_hits + water_drained
	var attack_val := card.attack
	await CardHelper.deal_damage(attack_val, num_hits, actor, target_char)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]
