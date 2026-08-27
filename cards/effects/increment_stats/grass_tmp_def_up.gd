class_name LeafShield
extends CardEffect

@export var def_value: int
@export var stacks: bool = true

func get_identifier() -> String:
	return "leaf_shield"
	
func get_description() -> String:
	return "Destroy adjacent grass. Temporarily increase defense of this card by the number of grass tiles destroyed."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var num_grass := CardHelper.mow_grass(actor.grid_position)
	var tmp_def := TmpDefUp.new()
	tmp_def.def_value = num_grass
	tmp_def.do(actor, target_char, card)
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !stacks:
		return self
	if self.is_same_effect(other_effect):
		self.def_value += (other_effect as TmpDefUp).def_value
	return self
