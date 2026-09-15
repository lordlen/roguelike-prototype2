class_name Sap
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "sap" if target == Target.ENEMY else "self-sap"

func get_description() -> String:
	return "Discard target bottom draw pile"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t):
		t.deck.discard_bottom()
	card_effect_finished.emit()
