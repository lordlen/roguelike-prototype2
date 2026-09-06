class_name CardEffect
extends Resource

signal card_effect_finished

enum Target {
	SELF,
	ENEMY
}

@export var is_temp: bool

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	card_effect_finished.emit()

func get_identifier() -> String:
	return ""

func get_description() -> String:
	return ""

func get_attack_value(card: CardInstance) -> int:
	return 0

func get_numeric() -> String:
	return ""

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self]

func get_shortform(card: CardInstance) -> String:
	var identifier := get_identifier()
	if is_temp:
		identifier += "(once)"
	if get_description():
		return "[color=orange]%s[/color]" % [identifier]
	return identifier

func get_shortform_desc() -> String:
	var numeric := get_numeric()
	if numeric == "":
		return "[color=orange]%s[/color]" % get_identifier()
	else:
		return "%s [color=orange]%s[/color]" % [numeric, get_identifier()]

func is_same_effect(other_effect: CardEffect) -> bool:
	return self.get_identifier() == other_effect.get_identifier()\
	and self.is_temp == other_effect.is_temp

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
