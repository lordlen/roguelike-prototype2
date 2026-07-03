class_name CardEffect
extends Resource

signal card_effect_finished

@export var identifier: String
@export var description: String

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	card_effect_finished.emit()

func get_description() -> String:
	return description

func is_same_effect(other_effect: CardEffect) -> bool:
	return self.identifier == other_effect.identifier

# only combines with same type
func combine_effect(other_effect: CardEffect) -> CardEffect:
	# by default, no combination happens. Just throw away the other effect
	return self

# put other effects into effects
static func combine_effects(effects: Array[CardEffect], other_effects: Array[CardEffect]):
	for other_effect: CardEffect in other_effects:
		# check the new array for some other effect that's equal
		var duplicate_effect_present := false
		for i in range(len(effects)):
			var effect: CardEffect = effects[i]
			if effect.is_same_effect(other_effect):
				duplicate_effect_present = true
				var new_effect := effect.combine_effect(other_effect)
				effects[i] = new_effect
				break
		if !duplicate_effect_present:
			effects.push_back(other_effect)
	return effects
