class_name IncrementAllAttackCard
extends CardEffect

@export var atk_value: int

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var increment_item_action = IncrementAllAttack.new()
	increment_item_action.value = atk_value
	increment_item_action.use(actor, actor.grid_position)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as IncrementAllAttackCard).atk_value
	return self

func get_description() -> String:
	return description % atk_value
