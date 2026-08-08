extends CardEffect

@export var atk_value: int
@export var tmp_attack_down: CardEffect

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card.attack += atk_value
	card.attack_effects.push_back(tmp_attack_down)
	
	card_effect_finished.emit()
