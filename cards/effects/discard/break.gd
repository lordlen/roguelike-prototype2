class_name Break
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "break" if target == Target.ENEMY else "self-break"

func get_description() -> String:
	return "Discard target off-hand"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t) and t.deck.offhand:
		var offhand := t.deck.offhand
		await offhand.do_on_discard_effects(t)
		# on use effects are typically used by temp stat ups.
		await offhand.do_on_use_effects(t)
		t.deck.discard_offhand()
	card_effect_finished.emit()
