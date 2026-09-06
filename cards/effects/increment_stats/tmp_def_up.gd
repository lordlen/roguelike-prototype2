class_name TmpDefUp
extends CardEffect

@export var def_value: int
@export var stacks: bool = true

func get_identifier() -> String:
	return "tmp_def_up"
	
func get_description() -> String:
	return "Temporarily increase defense of this card by n"

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	card.defense += def_value
	var def_down := DefUp.new()
	def_down.value = -def_value
	def_down.is_temp = true
	CardEffect.combine_effects(card.on_use_effects, [def_down])
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !stacks:
		return self
	if self.is_same_effect(other_effect):
		self.def_value += (other_effect as TmpDefUp).def_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [def_value, super.get_shortform(card)]
