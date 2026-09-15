class_name Disarm
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "disarm" if target == Target.ENEMY else "self-disarm"

func get_description() -> String:
	return "Discard target main-hand"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t) and t.deck.primary:
		var primary := t.deck.primary
		await primary.do_on_discard_effects(t)
		await primary.do_on_use_effects(t)
		t.deck.discard_primary()
	card_effect_finished.emit()
