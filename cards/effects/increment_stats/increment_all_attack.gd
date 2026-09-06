class_name IncrementAllAttackCard
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "all_atk_up"
	
func get_description() -> String:
	return "Increase attack by n for all cards in the deck."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var increment_item_action = IncrementAllAttack.new()
	increment_item_action.value = atk_value
	increment_item_action.use(actor, actor.grid_position)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as IncrementAllAttackCard).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
