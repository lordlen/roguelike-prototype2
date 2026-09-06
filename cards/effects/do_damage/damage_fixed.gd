class_name DamageFixed
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "patience"

func get_description() -> String:
	return "Deal n damage (ignores defense)."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var target_char := ActorManager.get_actor_in_position(target_pos)
	for i in range(card.num_hits):
		if !is_instance_valid(target_char):
			break
		target_char.take_damage(atk_value)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
