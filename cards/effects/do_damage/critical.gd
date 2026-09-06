class_name Critical
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "critical"

func get_description() -> String:
	return "Deal unblockable damage if target is not blocking."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var target_char := ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(target_char) and !target_char.is_defending:
		var damage_fixed := DamageFixed.new()
		damage_fixed.atk_value = value
		damage_fixed.do(actor, target_pos, card)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
