class_name ExhaustOff
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "exhaust_off"

func get_description() -> String:
	return "Exhaust the off-hand."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t):
		t.deck.offhand = null
	card_effect_finished.emit()
