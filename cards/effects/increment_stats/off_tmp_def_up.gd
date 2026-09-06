class_name OffTmpDefUp
extends CardEffect

@export var def_value: int
@export var target: Target

func get_identifier() -> String:
	return "off_tmp_def_up" if target == Target.ENEMY else "self-off_tmp_def_up"
	
func get_description() -> String:
	return "Temporarily increase off-hand def by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if t.deck.offhand:
		var tmp_def_up := TmpDefUp.new()
		tmp_def_up.def_value = def_value
		tmp_def_up.do(actor, target_pos, t.deck.offhand)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.def_value += (other_effect as OffTmpDefUp).def_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [def_value, super.get_shortform(card)]
