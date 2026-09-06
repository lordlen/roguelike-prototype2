class_name Invert
extends CardEffect

@export var target: Target

func get_identifier() -> String:
	return "invert" if target == Target.ENEMY else "self-invert"

func get_description() -> String:
	return "Swap the draw and discard pile."

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t):
		t.deck.invert_piles()
	card_effect_finished.emit()
