extends CardEffect

@export var atk_value: int
@export var tmp_attack_down: CardEffect
@export var stacks: bool

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	print("attack up tmp")
	card.attack += atk_value
	CardEffect.combine_effects(card.attack_effects, [tmp_attack_down.duplicate()])
	
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !stacks:
		return self
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as AtkUp).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
