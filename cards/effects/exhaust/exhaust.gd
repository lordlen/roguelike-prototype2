class_name Exhaust
extends CardEffect

@export var target: Target
@export var is_main: bool

func get_identifier() -> String:
	var t := "" if target == Target.ENEMY else "self-"
	var hand := "main" if is_main else "off"
	return "%s%s_exhaust" %[t, hand]

func get_description() -> String:
	return "Exhaust the %s-hand." % ["main" if is_main else "off"]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_main:
		t.deck.primary = null
	else:
		t.deck.offhand = null
	card_effect_finished.emit()
