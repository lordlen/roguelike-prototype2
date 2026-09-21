class_name OffhandAttack
extends CardEffect

func get_identifier() -> String:
	return "offhand_attack"

func get_description() -> String:
	return "Attack target with the off-hand."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var offhand := actor.deck.offhand
	var target_char := ActorManager.get_actor_in_position(target_pos)
	if offhand != null and is_instance_valid(target_char):
		offhand.do_attack.call_deferred(actor, target_char)
		await offhand.card_action_finished
		actor.deck.discard_offhand()
	card_effect_finished.emit()
