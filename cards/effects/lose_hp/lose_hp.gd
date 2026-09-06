class_name LoseHp
extends CardEffect

@export var value: int = 1

func get_identifier() -> String:
	return "lose_hp"
	
func get_description() -> String:
	return "Lose n hp."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	actor.take_damage(value)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as LoseHp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
