class_name ShivWeak
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "shiv_weak"
	
func get_description() -> String:
	return 'Add "-n main_tmp_atk_up" to all shivs'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, MainTmpAtkUp.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var shivs := actor.deck.find_all_cards("Shiv")
	for shiv in shivs:
		var effect := MainTmpAtkUp.new()
		effect.target = Target.ENEMY
		effect.atk_value = -value
		CardEffect.combine_effects(shiv.attack_effects, [effect])
	card_effect_finished.emit()
