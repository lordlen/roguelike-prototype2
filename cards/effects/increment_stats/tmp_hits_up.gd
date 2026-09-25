class_name TmpHitsUp
extends CardEffect

@export var value: int
@export var stacks: bool = true

func get_identifier() -> String:
	return "tmp_hits_up"
	
func get_description() -> String:
	return "Temporarily increase hits of this card by n"

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	card.num_hits += value
	var hits_up := HitsUp.new()
	hits_up.value = -value
	hits_up.is_temp = true
	CardEffect.combine_effects(card.on_use_effects, [hits_up])
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !stacks:
		return self
	if self.is_same_effect(other_effect):
		self.value += (other_effect as TmpHitsUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
