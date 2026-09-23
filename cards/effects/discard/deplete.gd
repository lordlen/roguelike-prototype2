class_name Deplete
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "deplete" if target == Target.ENEMY else "self-deplete"

func get_description() -> String:
	return "Discard the draw pile and hand."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t):
		await t.deck.discard_draw_pile()
		var break_action := Break.new()
		break_action.target = target
		await break_action.do(actor, target_pos, card)
		var disarm_action := Disarm.new()
		disarm_action.target = target
		await disarm_action.do(actor, target_pos, card)
	card_effect_finished.emit()
