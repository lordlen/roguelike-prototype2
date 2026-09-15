class_name DoDamage
extends CardEffect

@export var bonus_damage: int
@export var is_aoe: bool = false

func get_identifier() -> String:
	return "damage" if !is_aoe else "damage_AOE"

func get_numeric() -> String:
	return "n"

func get_attack_value(card: CardInstance) -> int:
	return card.attack

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	if is_aoe:
		var num_hits := card.num_hits
		var attack_val := card.attack
		var atk_range := card.atk_range
		CardHelper.deal_aoe_damage(attack_val, num_hits, actor, actor.grid_position, atk_range)
	else:
		var target_char := ActorManager.get_actor_in_position(target_pos)
		var num_hits := card.num_hits
		var attack_val := card.attack + bonus_damage
		await CardHelper.deal_damage(attack_val, num_hits, actor, target_char)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [card.get_attack(), super.get_shortform(card)]

func get_description() -> String:
	if is_aoe:
		return "Deal n damage to all enemies in range."
	else:
		return ""
