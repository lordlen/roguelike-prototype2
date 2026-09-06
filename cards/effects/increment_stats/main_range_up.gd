class_name MainTmpRangeUp
extends CardEffect

@export var value: int
@export var target: Target

func get_identifier() -> String:
	return "main_tmp_range_up" if target == Target.ENEMY else "self-main_tmp_range_up"
	
func get_description() -> String:
	return "Temporarily increase main hand range by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if t.deck.primary:
		var tmp_range_up := TmpRangeUp.new()
		tmp_range_up.value = value
		tmp_range_up.do(actor, target_pos, t.deck.primary)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as MainTmpRangeUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
